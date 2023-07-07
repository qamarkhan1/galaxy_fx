import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:forex_guru/backends/apis/misc_api.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/backends/apis/classes_api.dart';
import 'package:forex_guru/backends/currency_repo.dart';
import 'package:forex_guru/backends/apis/notify_repo.dart';
import 'package:forex_guru/backends/payment_repo.dart';
import 'package:forex_guru/backends/social_login.dart';
import 'package:forex_guru/backends/validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web3auth_flutter/output.dart';

import '../utils/biometrics.dart';
import 'apis/device_api.dart';
import 'apis/investment_api.dart';
import 'apis/payouts_api.dart';
import 'apis/signals_api.dart';
import 'apis/subscription_api.dart';
import 'apis/transaction_api.dart';
import 'apis/user_api.dart';
import 'apis/user_auth.dart';
import 'image_repo.dart';

class AllRepos {
  final CallFunctions _callFunctions = CallFunctions();
  final CurrencyApi _apis = CurrencyApi();
  final ClassesApi _classesApi = ClassesApi();
  final DevicesApi _devicesApi = DevicesApi();
  final InvestmentApi _investmentApi = InvestmentApi();
  final PayoutMethodsApi _payoutMethodsApi = PayoutMethodsApi();
  final SignalsApi _signalsApi = SignalsApi();
  final SubscriptionApi _subscriptionApi = SubscriptionApi();
  final TransactionsApi _transactionsApi = TransactionsApi();
  final UserApi _userApi = UserApi();
  final UserAuth _userAuth = UserAuth();
  final ValidatorsFxn _validatorsFxn = ValidatorsFxn();
  final BiometricsFxn _biometricsFxn = BiometricsFxn();
  final SocialLogin _socialLogin = SocialLogin();
  final NotificationRepo _notificationRepo = NotificationRepo();
  final MiscApi _miscApi = MiscApi();
  final ImageReceiptRepo _imageReceiptRepo = ImageReceiptRepo();
  final PaymentRepo _paymentRepo = PaymentRepo();

  launchUrlFxn(String url) => _callFunctions.launchUrlFxn(url);

  showSnacky(
    String msg,
    bool isSuccess, {
    Map<String, String>? args,
    String extra2 = '',
    String? title,
  }) =>
      _callFunctions.showSnacky(
        msg,
        isSuccess,
        args: args,
        extra2: extra2,
        title: title,
      );

  toggleSwitch(
    bool value,
    Function(bool) onChanged,
  ) =>
      _callFunctions.toggleSwitch(
        value,
        onChanged,
      );

  showPicker(
    context, {
    List<dynamic>? children,
    Function(int?)? onSelectedItemChanged,
    Function(String?)? onChanged,
    bool hasTrns = true,
  }) =>
      _callFunctions.showPicker(
        context,
        children: children,
        onSelectedItemChanged: onSelectedItemChanged,
        onChanged: onChanged,
        hasTrns: hasTrns,
      );

  showPopUp(
    Widget content,
    List<CupertinoButton> iosActions,
    // Function()? onConfirmm,
    List<TextButton> androidActions, {
    IconData? icon,
    String? msg,
    Color? color,
    bool barrierDismissible = true,
    Function()? onCancel,
  }) =>
      _callFunctions.showPopUp(
        content,
        iosActions,
        // onConfirmm,
        androidActions,
        barrierDismissible: barrierDismissible,
        onCancel: onCancel,
      );

  showModalBarAction(
    Widget child,
    List<CupertinoActionSheetAction> action,
  ) =>
      _callFunctions.showModalBarAction(
        child,
        action,
      );

  showModalBar(
    Widget content, {
    bool? isDismissible,
  }) =>
      _callFunctions.showModalBar(
        content,
        isDismissible: isDismissible,
      );

  showFlush(
    String message, {
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    bool? success,
  }) =>
      _callFunctions.showFlush(
        message,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        icon: icon,
        success: success,
      );

  snapshotFuture(
    AsyncSnapshot<dynamic> snapshot,
    Widget widget, {
    double? height = 0.0,
    bool hasBack = true,
    Widget? customEmpty,
  }) =>
      _callFunctions.snapshotFuture(
        snapshot,
        widget,
        height: height!,
        hasBack: hasBack,
        customEmpty: customEmpty,
      );
  String avatarManipulation(String name) =>
      _callFunctions.avatarManipulation(name);

  String getNewDate(String date) => _callFunctions.getNewDate(date);

  customDialog(Widget child) => _callFunctions.customDialog(child);
  cronJob(Function function, int when) =>
      _callFunctions.cronJob(function, when);

  // translation(dynamic  String key, {Map<String, String>? args}) =>
  //     _callFunctions.translation( key, args: args);

  // String? multiTranslation( List<String> keys,
  //         {Map<String, String>? args}) =>
  //     _callFunctions.multiTranslation( keys, args: args);

  currencyRatesGet() => _apis.currencyRatesGet();

  //! Classes

  Future<Map> getAllClasses() => _classesApi.getAllClasses();
  Future<List> getClassesContents(String ref) =>
      _classesApi.getClassesContents(ref);
  Future<List> getUserClasses() => _classesApi.getUserClasses();
  Future<bool> enroll(Map body) => _classesApi.enroll(body);
  Future<bool> rateCourse(Map body) => _classesApi.rateCourse(body);
  //! Devices

  Future<List> getAllDevices() => _devicesApi.getAllDevices();
  Future<bool> storeNewDevice() => _devicesApi.storeNewDevice();
  Future<bool> deleteDeviceHistory(String ref) =>
      _devicesApi.deleteDeviceHistory(ref);

  //! Investments

  Future<Map> getAllInvestments() => _investmentApi.getAllInvestments();
  Future<List> getAllInvestmentHistory() =>
      _investmentApi.getAllInvestmentHistory();

  Future<bool> makeInvest(Map body) => _investmentApi.makeInvest(body);

  //! Payouts

  Future<List> getAllPayoutMethods() => _payoutMethodsApi.getAllPayoutMethods();
  Future<bool> addNewPayoutMethod(Map data) =>
      _payoutMethodsApi.addNewPayoutMethod(data);
  Future<bool> updatePayoutMethod(Map data) =>
      _payoutMethodsApi.updatePayoutMethod(data);
  Future<bool> deletePayoutMethod(String id) =>
      _payoutMethodsApi.deletePayoutMethod(id);

  //! Signals

  Future<Map> getAllSignals() => _signalsApi.getAllSignals();

  //! Subscriptions

  Future<Map> getAllSubPlans() => _subscriptionApi.getAllSubPlans();
  Future<Map> getUserSubHistory() => _subscriptionApi.getUserSubHistory();
  Future<bool> subscribe(Map body) => _subscriptionApi.subscribe(body);

  //! Transactions

  Future<List> getAllTransactions() => _transactionsApi.getAllTransactions();
  Future<bool> depositFxn(Map body) => _transactionsApi.depositFxn(body);
  Future<bool> withdrawFxn(Map body) => _transactionsApi.withdrawFxn(body);

  //! User

  Future<Map> getUserData() => _userApi.getUserData();
  Future<Map> getUserRefDetails() => _userApi.getUserRefDetails();
  Future<bool> updateProfile(Map body) => _userApi.updateProfile(body);
  Future<List> getUserRefHistory() => _userApi.getUserRefHistory();
  Future<List> getUserRefEarningsAndPayoutsHistory() =>
      _userApi.getUserRefEarningsAndPayoutsHistory();

  //! UserAuth

  Future<bool> signUp(Map body) => _userAuth.signUp(body);
  Future<bool> signIn(Map body) => _userAuth.signIn(body);
  Future<bool> signOut() => _userAuth.signOut();
  Future<bool> resetPassRequest(Map body) => _userAuth.resetPassRequest(body);
  Future<bool> changePass(Map body) => _userAuth.changePass(body);
  Future<bool> twoFASet() => _userAuth.twoFASet();
  Future<bool> twoFADisable() => _userAuth.twoFADisable();
  twoFAQRCode() => _userAuth.twoFAQRCode();
  Future<Map> twoFARecoveryCode() => _userAuth.twoFARecoveryCode();
  Future<bool> deleteAccount(Map body) => _userAuth.deleteAccount(body);
  Future<Map> emailVerificationLink() => _userAuth.emailVerificationLink();
  Future<bool> resendEmailVerification(Map body) =>
      _userAuth.resendEmailVerification(body);
  Future<Map> socialLogin(Map body) => _userAuth.socialLogin(body);

  //! Validation

  String? validateEmpty(String? valu) => _validatorsFxn.validateEmpty(valu);
  String? validateName(String? value) => _validatorsFxn.validateName(value);
  String? validateEmail(String? value) => _validatorsFxn.validateEmail(value);
  String? validatePassword(String? value) =>
      _validatorsFxn.validatePassword(value);
  String? validateCPassword(String value, String password) =>
      _validatorsFxn.validateCPassword(value, password);

  String? validateAmount(
    bool hasBal,
    String value,
    double balance,
    double minimum,
    double maximum,
  ) =>
      _validatorsFxn.validateAmount(
        hasBal,
        value,
        balance,
        minimum,
        maximum,
      );

  //! Biometrics
  Future<bool?> checkAvailability() => _biometricsFxn.checkAvailability();
  Future<String?> getAvailableBiometric() =>
      _biometricsFxn.getAvailableBiometric();
  Future<bool?> authenticate() => _biometricsFxn.authenticate();

  //! Social Login
  Future<Web3AuthResponse> withGoogle() => _socialLogin.withGoogle();
  Future<Web3AuthResponse> withFacebook() => _socialLogin.withFacebook();
  Future<Web3AuthResponse> withTwitter() => _socialLogin.withTwitter();
  Future<Web3AuthResponse> withApple() => _socialLogin.withApple();

  //! Notiifcation Repo

  requestNotificationPermission() =>
      _notificationRepo.requestNotificationPermission();
  foregroundMessage() => _notificationRepo.foregroundMessage();
  backgroundMessage() => _notificationRepo.backgroundMessage();
  subscribeToTopics(String topic) => _notificationRepo.subscribeToTopics(topic);
  unSubscribeFromTopics(String topic) =>
      _notificationRepo.unSubscribeFromTopics(topic);

  Future<void> getUserSettings() => _notificationRepo.getUserSettings();
  Future<bool> updateNotificationStatus(Map data) =>
      _notificationRepo.updateNotificationStatus(data);

  Future<List> getAllNotifications() => _notificationRepo.getAllNotifications();
  Future<void> setupToken() => _notificationRepo.setupToken();

  Future<void> sendPushNotification(Map data) =>
      _notificationRepo.sendPushNotification(data);
  Future<void> sendEmailNotification(Map data) =>
      _notificationRepo.sendEmailNotification(data);
  //! ExtrasRepo

  Future<void> getMore() => _miscApi.getMore();

  //! Misc

  Widget viewFxn(double height, double width, Function()? onTap,
          String? exImage, XFile? imageFile, BuildContext context) =>
      _imageReceiptRepo.viewFxn(
          height, width, onTap, exImage, imageFile, context);

  Widget handlePreview(String? exImage, XFile? imageFile, Widget viewFxn) =>
      _imageReceiptRepo.handlePreview(exImage, imageFile, viewFxn);

  Future<XFile?> retrieveLostData() => _imageReceiptRepo.retrieveLostData();

  Future<CroppedFile?> cropImage(imageFile) =>
      _imageReceiptRepo.cropImage(imageFile);

  //!PaymentRepo

  void initPaystack() => _paymentRepo.initPaystack();
  Future<Map> paystackPayment(double amount) =>
      _paymentRepo.paystackPayment(amount);

  handleCheckout(
          PaymentCard getCardFromUI, CheckoutMethod method, String amount) =>
      _paymentRepo.handleCheckout(getCardFromUI, method, amount);

  Future<bool> handlePayPress(CardFormEditController controller, int amount) =>
      _paymentRepo.handlePayPress(controller, amount);

  ugMobileMoney(Map data) => _paymentRepo.ugMobileMoney(data);
}
