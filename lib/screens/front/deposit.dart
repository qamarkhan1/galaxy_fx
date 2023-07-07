import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_text_field.dart';
import 'package:forex_guru/widgets/cust_tile.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../widgets/loading_button.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

TextEditingController amountCtrl = TextEditingController();
TextEditingController hashCtrl = TextEditingController();
TextEditingController phoneCtrl = TextEditingController();

class _DepositScreenState extends State<DepositScreen> {
  AllRepos allRepos = AllRepos();
  String payMethod = mobileMoneyAuto;
  String coinToken = bitcoin;
  static final settingsBx = Hive.box(settings);
  Map dt = settingsBx.get(more) ?? {};

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  String? _paystackCardNumber;
  String? _paystackCvv;
  int? _paystackExpiryMonth;
  int? _paystackExpiryYear;

  final controller = CardFormEditController();

  @override
  void initState() {
    allRepos.initPaystack();
    controller.addListener(update);

    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustScaffold(
      title: 'Deposit',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: ValueListenableBuilder(
              valueListenable: settingsBx.listenable(),
              builder: (context, Box bxDt, widget) {
                Map coin = bxDt.get(more);
                return Column(
                  children: [
                    CustTextField(
                      hintText: '1000',
                      lableText: payMethod == mobileMoneyManual ||
                              payMethod == mobileMoneyAuto
                          ? 'Amount in UGX'
                          : 'Amount',
                      controller: amountCtrl,
                    ),
                    const SizedBox(height: 10),

                    payMethod == mobileMoneyManual ||
                            payMethod == mobileMoneyAuto
                        ? CustTextField(
                            hintText: '+256788',
                            lableText: 'Phone Number',
                            controller: phoneCtrl,
                          )
                        : const SizedBox.shrink(),
                    ListTile(
                      title: const Text('Payment Method'),
                      trailing: InkWell(
                        onTap: () {
                          allRepos.showPicker(
                            context,
                            children: depositMethods,
                            hasTrns: false,
                            onChanged: (String? val) {
                              payMethod = val!;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            onSelectedItemChanged: (int? index) {
                              payMethod = depositMethods[index!];
                              setState(() {});
                            },
                          );
                        },
                        child: Text(
                          payMethod.capitalize(),
                        ),
                      ),
                    ),
                    payMethod == mobileMoneyAuto
                        ? Column(
                            children: [
                              CustButton(
                                onTap: processMMA,
                                title: 'Proceed',
                              ),
                            ],
                          )
                        : payMethod == mobileMoneyManual
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Airtel MERCHANT ID: 6328376 (Registered Names: GalaxyVentures)',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text('INSTRUCTIONS',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  const Text('Step 1: Dial *185*9#',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  const Text(
                                      'Step 2: Enter Merchant ID (Airtel MERCHANT ID: 6328376)',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  const Text(
                                      'Step 3: Enter amount you want to deposit',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  const Text('Step 4: Put in your Pin',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  const Text(
                                      'Fill in the amount you have sent to our merchant ID and your phone number',
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 20),
                                  CustButton(
                                      onTap: processMMM, title: 'Proceed'),
                                ],
                              )
                            : payMethod == cryptocurrency
                                ? Column(
                                    children: [
                                      ListTile(
                                        title: const Text('Coin/Token'),
                                        trailing: GestureDetector(
                                          onTap: () => allRepos.showPicker(
                                            context,
                                            children: cryptoList,
                                            hasTrns: false,
                                            onChanged: (String? val) {
                                              coinToken = val!;
                                              setState(() {});
                                            },
                                            onSelectedItemChanged:
                                                (int? index) {
                                              coinToken = cryptoList[index!];
                                              setState(() {});
                                            },
                                          ),
                                          child: Text(
                                            coinToken.capitalize(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        height: 220,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color!
                                                  .withOpacity(0.5),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              QrImage(
                                                data: (erc20List
                                                            .contains(coinToken)
                                                        ? coin[erc20]
                                                        : coin[coinToken]) ??
                                                    "",
                                                version: QrVersions.auto,
                                                size: 150.0,
                                              ),
                                              Text(
                                                (erc20List.contains(coinToken)
                                                        ? coin[erc20]
                                                        : coin[coinToken]) ??
                                                    "loading",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustTextField(
                                        hintText: 'Enter Transaction Hash',
                                        lableText: 'Trxn Hash',
                                        controller: hashCtrl,
                                      ),
                                      const SizedBox(height: 10),
                                      CustButton(
                                          onTap: processCrypto,
                                          title: 'Proceed'),
                                    ],
                                  )
                                : payMethod == bank
                                    ? Column(
                                        children: [
                                          CustTile(
                                              title: 'Bank Name',
                                              trailing:
                                                  Text(dt['bank_name'] ?? "")),
                                          CustTile(
                                              title: 'Account Name',
                                              trailing: Text(
                                                  dt['account_name'] ?? "")),
                                          CustTile(
                                              title: 'Account Number',
                                              trailing: Text(
                                                  dt['bank_account'] ?? "")),
                                          CustTile(
                                              title: 'Sort Code',
                                              trailing:
                                                  Text(dt['sort_code'] ?? "")),
                                          CustTile(
                                              title: 'Swift Code',
                                              trailing:
                                                  Text(dt['swift_code'] ?? "")),
                                          CustTile(
                                              title: 'Iban',
                                              trailing: Text(dt['iban'] ?? "")),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _imageFile == null
                                                  ? GestureDetector(
                                                      onTap: () =>
                                                          madeBankPaymentFxn(),
                                                      child: Text(
                                                        'Click to Upload Receipt',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6,
                                                      ),
                                                    )
                                                  : Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 300,
                                                          width: 300,
                                                          child: viewFunction(
                                                              dialogState:
                                                                  setState),
                                                        ),
                                                        Text(
                                                          'Receipt',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          CustButton(
                                              onTap: bankImageProof,
                                              title: 'Proceed'),
                                        ],
                                      )
                                    : payMethod == stripe
                                        ? Column(
                                            children: [
                                              stripeWidget(),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              CustButton(
                                                onTap: payStack,
                                                title: 'Proceed',
                                              ),
                                            ],
                                          )
                    // appPayButton(),
                  ],
                );
              }),
        ),
      ),
    );
  }

  // final List<PaymentItem> _paymentItems = [
  //   PaymentItem(
  //     label: 'Wallet Deposit',
  //     amount: amountCtrl.text,
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];

  // appPayButton() {
  //   return Column(
  //     children: [
  //       ApplePayButton(
  //         paymentConfigurationAsset:
  //             'pay/default_payment_profile_apple_pay.json',
  //         paymentItems: [
  //           PaymentItem(
  //             label: 'Wallet Deposit',
  //             amount: amountCtrl.text,
  //             // status: PaymentItemStatus.final_price,
  //             type: PaymentItemType.total,
  //           )
  //         ],
  //         style: ApplePayButtonStyle.whiteOutline,
  //         type: ApplePayButtonType.topUp,
  //         margin: const EdgeInsets.only(top: 15.0),
  //         onPaymentResult: onApplePayResult,
  //         loadingIndicator: const Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //         height: 50,
  //         width: double.infinity,
  //       ),
  //       GooglePayButton(
  //         paymentConfigurationAsset:
  //             'pay/default_payment_profile_google_pay.json',
  //         paymentItems: [
  //           PaymentItem(
  //             label: 'Wallet Deposit',
  //             amount: amountCtrl.text,
  //             status: PaymentItemStatus.final_price,
  //           )
  //         ],
  //         type: GooglePayButtonType.pay,
  //         margin: const EdgeInsets.only(top: 15.0),
  //         onPaymentResult: onGooglePayResult,
  //         loadingIndicator: const Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //         height: 50,
  //         width: double.infinity,
  //       ),
  //     ],
  //   );
  // }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: _paystackCardNumber,
      cvc: _paystackCvv,
      expiryMonth: _paystackExpiryMonth,
      expiryYear: _paystackExpiryYear,
    );
  }

  payStack() async {
    int amount = (double.parse(amountCtrl.text.trim()) * 100).toInt();

    var response = await allRepos.handleCheckout(
        _getCardFromUI(), CheckoutMethod.selectable, '$amount');

    if (response.runtimeType == CheckoutResponse) {
      if (response.status && response.message == 'Success') {
        Map data = {
          'reference': response.reference,
          'payment_method': paystack,
          'hash': response.reference,
          'payment_sub': response.card!.cvc == null ? 'Bank' : 'Card',
          'status': 'completed',
        };
        _uploadFxn(data);
        allRepos.showFlush('Payment Success', success: true);
      } else {
        allRepos.showFlush('Payment Failed', success: false);
      }
    } else {
      if (response['message'] == 'Currency not supported by merchant') {
        allRepos.showFlush('Currency not supported by merchant',
            success: false);
      }
    }
  }

  stripeWidget() {
    // allRepos.customDialog(
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child:
          //  StatefulBuilder(builder: (context, dialogState) {
          //   return

          Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CardFormField(
            controller: controller,
            countryCode: 'US',
            style: CardFormStyle(
              borderColor: Colors.blueGrey,
              textColor: Colors.black,
              fontSize: 18,
              placeholderColor: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          LoadingButton(
            onPressed:
                controller.details.complete == true ? () => stripeFxn() : null,
            text: 'Pay',
          ),
          // CustButton(
          //   onTap: controller.details.complete == true
          //       ? () => allRepos.handlePayPress(controller)
          //       : null,
          //   title: 'Pay',
          // )
        ],
      ),
      // }),
    );
    // );
  }

  stripeFxn() {
    try {
      int amount = (double.parse(amountCtrl.text.trim()) * 100).toInt();
      return allRepos.handlePayPress(controller, amount).then((value) {
        Map data = {
          'payment_method': stripe,
          'payment_sub': 'Card',
          'status': 'completed',
        };
        _uploadFxn(data);
      });
    } catch (e) {
      allRepos.showFlush(defaultError);
    }
  }

  // void onApplePayResult(paymentResult) {
  //   try {
  //     setState(() {});
  //     String token = paymentResult['token'];

  //     if (token.trim().isNotEmpty) {
  //       Map data = {
  //         'payment_method': cryptocurrency,
  //         'hash': token.trim(),
  //         'payment_sub': applePay,
  //       };
  //       _uploadFxn(data);
  //     } else {
  //       allRepos.showFlush('Token is empty', success: false);
  //     }
  //   } catch (e) {
  //     allRepos.showFlush(defaultError);
  //   }
  //   // Send the resulting Apple Pay token to your server / PSP
  // }

  // void onGooglePayResult(paymentResult) {
  //   try {
  //     String token = paymentResult['tokenizationData']['token'];

  //     if (token.trim().isNotEmpty) {
  //       Map data = {
  //         'payment_method': appPay,
  //         'hash': token.trim(),
  //         'payment_sub': googlePay,
  //       };
  //       _uploadFxn(data);
  //     } else {
  //       allRepos.showFlush('Token is empty', success: false);
  //     }
  //   } catch (e) {
  //     allRepos.showFlush(defaultError);
  //   }
  // }

  processMMA() async {
    if (phoneCtrl.text.trim().isNotEmpty) {
      Map data = {
        'amount': amountCtrl.text.trim(),
        'phone_number': phoneCtrl.text.trim(),
      };
      Map res = await allRepos.ugMobileMoney(data);
      // _uploadFxn(data);

      allRepos.showFlush(res['message'], success: res['status']);
    } else {
      allRepos.showFlush('Phone is empty', success: false);
    }
  }

  processMMM() {
    if (phoneCtrl.text.trim().isNotEmpty) {
      Map data = {
        'payment_method': mobileMoneyManual,
        'hash': phoneCtrl.text.trim(),
      };
      _uploadFxn(data);
    } else {
      allRepos.showFlush('Phone is empty', success: false);
    }
  }

  processCrypto() {
    if (hashCtrl.text.trim().isNotEmpty) {
      Map data = {
        'payment_method': cryptocurrency,
        'hash': hashCtrl.text.trim(),
        'payment_sub': coinToken,
      };
      _uploadFxn(data);
    } else {
      allRepos.showFlush('Hash is empty', success: false);
    }
  }

  madeBankPaymentFxn() {
    allRepos.customDialog(
      Material(
        color: transparent,
        child: StatefulBuilder(builder: (context, dialogState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Image Receipt',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                if (_imageFile != null)
                  Platform.isAndroid
                      ? FutureBuilder<void>(
                          future: allRepos.retrieveLostData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const Text(
                                  'You have not yet picked an image.',
                                  textAlign: TextAlign.center,
                                );
                              case ConnectionState.done:
                                return allRepos.handlePreview(
                                  null,
                                  _imageFile,
                                  viewFunction(dialogState: dialogState),
                                );
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Image error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return const Text(
                                    'You have not yet picked an image.',
                                    textAlign: TextAlign.center,
                                  );
                                }
                            }
                          },
                        )
                      : allRepos.handlePreview(
                          null,
                          _imageFile,
                          viewFunction(dialogState: dialogState),
                        )
                else
                  viewFunction(dialogState: dialogState),
                const SizedBox(height: 10),
                CustButton(
                  onTap: () => Get.back(),
                  title: 'Close',
                  isHollow: true,
                )
              ],
            ),
          );
        }),
      ),
      // [
      //   CupertinoButton(
      //     child: const Text('Upload'),
      //     onPressed: () => bankImageProof(),
      //   ),
      //   CupertinoButton(
      //     child: const Text('Cancel'),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ],
      // [
      //   TextButton(
      //     child: const Text('Upload'),
      //     onPressed: () => bankImageProof(),
      //   ),
      //   TextButton(
      //     child: const Text('Cancel'),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ],
    );
  }

  final double _height = 200.0;
  final double _width = double.infinity;
  Widget viewFunction({dialogState}) {
    return allRepos.viewFxn(
      _height,
      _width,
      () async {
        final pickedFileList =
            await _picker.pickImage(source: ImageSource.gallery);
        dialogState(() {
          _imageFile = pickedFileList;
        });
        setState(() {});
      },
      null,
      _imageFile,
      context,
    );
  }

  bankImageProof() async {
    setState(() {
      // isLoading = true;
    });

    try {
      if (_imageFile!.path.isNotEmpty) {
        Map data = {
          'receipt': _imageFile!.path,
          'payment_method': bank,
        };
        await _uploadFxn(data);
      } else {
        allRepos.showFlush('Amount is empty', success: false);
      }
      // Map data = {
      //   'receipt': _imageFile!.path,
      // };
      // await _uploadFxn(data);
    } catch (e) {
      if (kDebugMode) {
        print('e $e');
      }
    }
    setState(() {
      // isLoading = false;
    });
  }

  _uploadFxn(Map data) {
    try {
      if (amountCtrl.text.trim().isNotEmpty) {
        var currRate = settingsBx.get(activeRate) ?? defaultRate;

        String amount = (double.parse(amountCtrl.text.trim()) / currRate)
            .toStringAsFixed(2);
        Map body = {
          'amount': amount,
          'trnx_type': deposit,
        };

        body.addAll(data);

        allRepos.depositFxn(body);
      } else {
        allRepos.showFlush('Amount is empty', success: false);
      }
    } catch (e) {
      allRepos.showFlush(defaultError, success: false);
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
