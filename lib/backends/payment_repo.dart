import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uganda_mobile_money/client.dart';
import 'package:uganda_mobile_money/uganda_mobile_money.dart';

import '../widgets/logo_widget.dart';
import 'call_functions.dart';

abstract class BasePaymentRepo {
  void initPaystack();
  Future<Map> paystackPayment(double amount);
  handleCheckout(
      PaymentCard getCardFromUI, CheckoutMethod method, String amount);

  Future<bool> handlePayPress(CardFormEditController controller, int amount);

  void initUGMobilePay();
  Future handleUGPayment();
  verifyUGTransaction(String taxRef, BuildContext context);
  ugMobileMoney(Map data);
}

class PaymentRepo extends GetConnect implements BasePaymentRepo {
  final CallFunctions _callFunctions = CallFunctions();

  static final settingsBx = Hive.box(settings);
  String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;

  static final userBox = Hive.box(users);
  static Map userProfile = userBox.get('userProfile') ?? {};
  String userEmail = userProfile['email'] ?? "";
  String name = userProfile['name'] ?? "";

  final _paystack = PaystackPlugin();

  String backendUrl = dotenv.env['PAYSTACK_SERVER_URL']!;
  String paystackPublicKey = dotenv.env['PAYSTACK_PUB_KEY']!;

  String stripeUrl = dotenv.env['STRIPE_URL']!;
  String webUrl = dotenv.env['ENDPOINT_URL']!;

  @override
  void initPaystack() {
    _paystack.initialize(publicKey: dotenv.env['PAYSTACK_PUB_KEY']!);
  }

  @override
  Future<Map> paystackPayment(double amount) async {
    Map dt = {};
    try {
      String? accessCode = await _getAccessCode(amount, userEmail);

      if (accessCode != null) {
        Charge charge = Charge()
          ..amount = (amount * 100).toInt()
          ..accessCode = accessCode
          ..email = email
          ..currency = curr.toUpperCase();

        CheckoutResponse response = await _paystack.checkout(
          Get.overlayContext!,
          method: CheckoutMethod.selectable,
          charge: charge,
        );

        if (response.status) {
          String resMessage =
              'Charge was successful. Ref: ${response.reference}';

          //Store Trxn
          dt = {
            status: true,
            message: resMessage,
          };
          _callFunctions.showPopUp(Text(resMessage), [
            CupertinoButton(
              child: const Text("Ok"),
              onPressed: () => Get.back(),
            ),
          ], [
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Get.back(),
            ),
          ]);
        } else {
          dt = {
            status: false,
            message: 'Failed',
          };
          _callFunctions.showSnacky('Failed:', false, extra2: response.message);
        }
      } else {
        dt = {
          status: false,
          message: 'Payment Error',
        };
        _callFunctions.showSnacky("Payment Error", false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return dt;
  }

  _getAccessCode(double amount, String email) async {
    String? paystackkey = dotenv.env['paystack_s_key'];

    Map<String, String> headers = {
      'Content-type': 'application/json',
      "Authorization": "Bearer $paystackkey"
    };

    if (paystackCurrencies.contains(curr)) {
      try {
        String url = "https://api.paystack.co/transaction/initialize";
        Map data = {
          "email": email,
          "amount": "${amount * 100}",
          "currency": curr.toUpperCase(),
          "channels": [
            'card',
            'bank',
            'ussd',
            'qr',
            'mobile_money',
            'bank_transfer'
          ]
        };
        Response response = await post(
          url,
          data,
          headers: headers,
        );
        var body = response.body;

        return body['data']["access_code"];
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      _callFunctions.showSnacky(
        "Unsupported Currency Type ${curr.toUpperCase()}",
        false,
      );
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  handleCheckout(
      PaymentCard getCardFromUI, CheckoutMethod method, String amount) async {
    CheckoutResponse response;
    Charge charge = Charge()
      ..amount = int.parse(amount)
      ..email = userEmail
      ..card = getCardFromUI;

    var accessCode = await _fetchAccessCodeFrmServer(_getReference(), amount);

    if (accessCode == 'Currency not supported by merchant') {
      return {
        status: false,
        message: 'Currency not supported by merchant',
      };
    } else {
      charge.accessCode = accessCode;

      try {
        response = await _paystack.checkout(
          Get.overlayContext!,
          method: method,
          charge: charge,
          fullscreen: false,
          logo: const CustAppLogo(),
        );
        return response;
      } catch (e) {
        _callFunctions.showFlush(defaultError, success: false);
        rethrow;
      }
    }
  }

  Future<String?> _fetchAccessCodeFrmServer(
      String reference, String amount) async {
    String url = '$backendUrl/new-access-code';
    String? accessCode;
    try {
      Response response = await get('$url/$amount/$userEmail/$curr');

      var body = response.body;

      if (body.runtimeType == String) {
        accessCode = body;
      } else {
        accessCode = body['error'][message];
      }

      // if (body['error'][status] == false) {
      //   accessCode = body['error'][message];
      //   print('accessCode2 $accessCode');
      // } else {
      //   print('accessCode3 $accessCode');
      // }
      // print('accessCode5 $accessCode');
    } catch (e) {
      _callFunctions.showFlush(
          'Reference: $reference \n Response: ${'There was a problem getting a new access code form'
              ' the backend: $e'}',
          success: false);
    }

    return accessCode;
  }

  @override
  Future<bool> handlePayPress(
      CardFormEditController controller, int amount) async {
    bool resStatus = false;
    if (!controller.details.complete) {
      return false;
    }

    try {
      // 1. Gather customer billing information (ex. email)

      final billingDetails = BillingDetails(
        email: userEmail,
        // phone: '+48888000888',
        // address: Address(
        //   city: 'Houston',
        //   country: 'US',
        //   line1: '1459  Circle Drive',
        //   line2: '',
        //   state: 'Texas',
        //   postalCode: '77063',
        // ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: curr, // mocked data
        // items: ['id-1'],
        amount: amount,
      );

      if (paymentIntentResult['error'] != null) {
        // Error during creating or confirming Intent

        _callFunctions.showFlush('Error: ${paymentIntentResult['error']}',
            success: false);

        return false;
      } else {
        if (paymentIntentResult['clientSecret'] != null &&
            paymentIntentResult['requiresAction'] == null) {
          // Payment succedeed

          _callFunctions.showFlush(
              'Success!: The payment was confirmed successfully!',
              success: true);
          resStatus = true;
          return true;
        } else if (paymentIntentResult['clientSecret'] != null &&
            paymentIntentResult['requiresAction'] == true) {
          // 4. if payment requires action calling handleNextAction
          final paymentIntent = await Stripe.instance
              .handleNextAction(paymentIntentResult['clientSecret']);

          // todo handle error
          /*if (cardActionError) {
        Alert.alert(
        `Error code: ${cardActionError.code}`,
        cardActionError.message
        );
      } else*/

          if (paymentIntent.status ==
              PaymentIntentsStatus.RequiresConfirmation) {
            // 5. Call API to confirm intent
            await confirmIntent(paymentIntent.id);
          } else {
            // Payment succedeed
            _callFunctions.showFlush('Error: ${paymentIntentResult['error']}',
                success: false);
          }
        }
      }
    } catch (e) {
      _callFunctions.showFlush('Error: $e');

      rethrow;
    }

    return resStatus;
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    if (result['error'] != null) {
      _callFunctions.showFlush('Error: ${result['error']}', success: false);
    } else {
      _callFunctions.showFlush(
          'Success!: The payment was confirmed successfully!',
          success: true);
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = '$stripeUrl/charge-card-off-session';
    final response = await post(
      url,
      {'paymentIntentId': paymentIntentId},
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.body;
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    // List<String>? items,
    int? amount,
  }) async {
    final url = '$stripeUrl/pay-without-webhooks';

    Response? response;
    try {
      response = await post(
        url,
        {
          'useStripeSdk': useStripeSdk,
          'paymentMethodId': paymentMethodId,
          'currency': currency,
          // 'items': items,
          'amount': amount,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('e $e');
      }
    }
    return response!.body;
  }

  late UgandaMobileMoney _mobileMoney;
  @override
  void initUGMobilePay() {
    const secretKey = "FLWSECK-XXXXX-X"; // flutterwave secret key
    _mobileMoney = UgandaMobileMoney(secretKey: secretKey);
  }

  @override
  Future handleUGPayment() async {
    MomoPayResponse response = await _mobileMoney.chargeClient(
      MomoPayRequest(
          txRef: "MC-01928403", // should be unique for each transaction
          amount: "1500", // amount in UGX you want to charge
          email: "tst@gmail.com", // email of the person you want to charge
          phoneNumber: "256123456723", // clients phone number
          fullname: "Ojangole Joran", // full name of client
          redirectUrl: "https://yoursite.com", // redirect url after payment
          voucher: "128373", // useful for vodafone. you can ignore this
          network: UgandaNetwork.mtn // network, can be either mtn or airtel
          ),
    );

    if (kDebugMode) {
      print(response.message);
    }
  }

  @override
  verifyUGTransaction(String taxRef, BuildContext context) {
    _mobileMoney.verifyTransaction(taxRef).then((value) {
      if (value == TransactionStatus.failed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      } else if (value == TransactionStatus.pending) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pending")));
      } else if (value == TransactionStatus.success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Success")));
      } else if (value == TransactionStatus.unknown) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Unknown")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Unknown")));
      }
    });
  }

  @override
  ugMobileMoney(Map data) async {
    //  $data = [
    //     "req" => "mobile_money",
    //     "currency" => "UGX",
    //     "phone" => $request_body->phone_number,
    //     "encryption_key" => "",
    //     "amount" => $request_body->amount,
    //     "user" => $request_body->user,
    //     "emailAddress" => "payments@{$_SERVER['SERVER_NAME']}",
    //     'url' => "https://{$_SERVER['SERVER_NAME']}/callback?u={$request_body->user}&callback={$request_body->ref}&email={$request_body->email}",
    //     "trx" => $request_body->ref
    // ];

    try {
      List splittedNames = name.split(' ');
      String ref = randomString(8);
      Map body = {
        "req": "mobile_money",
        "currency": "UGX",
        "phone": data['phone_number'],
        "encryption_key": "",
        "amount": data['amount'],
        "user": splittedNames.first,
        "emailAddress": userEmail,
        'url':
            "$webUrl/callback?u=${splittedNames.first}&callback=$ref&email=$userEmail",
        "trx": ref
      };
      await post('https://ugshop.store/playload2', body);
      _callFunctions.showSnacky('Payment sent', true);
    } catch (e) {
      log('e $e');
      _callFunctions.showSnacky('Error', false);
    }
  }
}
