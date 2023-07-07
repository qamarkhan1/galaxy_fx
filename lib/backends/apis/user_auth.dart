// Sign Up
// Sign in
// Forgot Pass request
// Reset pass
// change pass
// two factor auth
// update profile
// Delete

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/apis/notify_repo.dart';
import 'package:forex_guru/backends/apis/user_api.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/screens/start_page.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

abstract class BaseUserAuth {
  Future<bool> signUp(Map body);
  Future<bool> signIn(Map body);
  Future<Map> socialLogin(Map body);
  Future<bool> signOut();
  Future<bool> resetPassRequest(Map body);
  Future<bool> changePass(Map body);
  twoFASet();
  Future<bool> twoFAConfirm(Map body);
  Future<bool> twoFADisable();
  twoFAQRCode();
  Future<Map> twoFARecoveryCode();
  Future<bool> deleteAccount(Map body);
  Future<Map> emailVerificationLink();
  Future<bool> resendEmailVerification(Map body);
}

class UserAuth extends GetConnect implements BaseUserAuth {
  String url = dotenv.env['ENDPOINT_URL']!;
  String apiUrl = dotenv.env['ENDPOINT_URL_API']!;
  final _box = Hive.box(users);
  final _settingsBx = Hive.box(settings);
  CallFunctions callFunctions = CallFunctions();
  UserApi userApi = UserApi();
  NotificationRepo notificationRepo = NotificationRepo();

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  Future<bool> changePass(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${apiUrl}updatePassword',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage, success: true);
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage, success: false);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<bool> deleteAccount(Map body) async {
    bool resStatus = false;
    try {
      Response response = await delete(
        '${apiUrl}users/delete',
        headers: getHeader(),
      );

      var responseBody = response.body;
      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage);
        Get.to(StartPageScreen());
        _box.clear();
        _settingsBx.clear();
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<bool> resetPassRequest(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${url}forgot-password',
        body,
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage);
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<bool> signIn(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post('${apiUrl}login', body);
      var responseBody = response.body;

      if (responseBody[status]) {
        await post('${url}login', body); // Fortify Session

        String accessToken = responseBody['access_token'];
        _box.put('accessToken', accessToken);
        _box.put('password', body['password']);
        notificationRepo.setupToken();

        for (var element in topics) {
          notificationRepo.subscribeToTopics(element);
        }

        notificationRepo.getAllNotifications();
        notificationRepo.getUserSettings();
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }

      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<bool> signOut() async {
    bool resStatus = false;
    try {
      Get.to(StartPageScreen());
      _box.clear();

      Response response = await post(
        '${apiUrl}logout',
        null,
        headers: getHeader(),
      );
      var responseBody = response.body;

      if (responseBody[status]) {
        post('${url}logout', null); // Fortify Session
        await Web3AuthFlutter.logout();

        resStatus = responseBody[status];
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
    }

    return resStatus;
  }

  @override
  Future<bool> signUp(Map body) async {
    bool resStatus = false;
    try {
      post('${url}logout', null); // Fortify Session

      Response response = await post('${url}register', body);

      log('response ${response.body}');
      if (response.statusCode == 302) {
        await post('${apiUrl}register', body);
        // }
        // var responseBody = response.body;

        // if (responseBody[status]) {
        // String resMessage = responseBody[message];
        Get.back();
        callFunctions.showFlush('Success, Please check your mailbox',
            success: true);
        resStatus = true;
      } else {
        // String errorMessage = responseBody[message];
        callFunctions.showFlush('Failed, Please try again');

        resStatus = false;
      }

      // status = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  twoFASet() async {
    // bool status = false;
    try {
      await post(
        '${url}user/two-factor-authentication',
        null,
        headers: getHeader(),
      );

      // status = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // return status;
  }

  @override
  Future<bool> twoFAConfirm(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${url}user/confirmed-two-factor-authentication',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage);
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<bool> twoFADisable() async {
    bool resStatus = false;
    try {
      Response response = await delete(
        '${url}user/two-factor-authentication',
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage);
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  twoFAQRCode() async {
    try {
      await twoFASet();
      await confirmPassword();
      await get(
        '${url}user/two-factor-qr-code',
        // headers: getHeader(),
      );

      // if (responseBody[status]) {
      //   twoFaQRCode = responseBody[message];
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<Map> twoFARecoveryCode() async {
    Map twoFaRecoveryCode = {};
    try {
      Response response = await get(
        '${url}user/two-factor-recovery-codes',
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        twoFaRecoveryCode = responseBody[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return twoFaRecoveryCode;
  }

  @override
  Future<bool> resendEmailVerification(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${url}email/verification-notification',
        body,
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage);
      } else {
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage);
      }
      resStatus = responseBody[status];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return resStatus;
  }

  @override
  Future<Map> emailVerificationLink() async {
    Map twoFaRecoveryCode = {};
    try {
      Response response = await get(
        '${url}email/verify',
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        twoFaRecoveryCode = responseBody[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return twoFaRecoveryCode;
  }

  confirmPassword() async {
    try {
      String password = _box.get('password');

      Map body = {'password': password};
      await post(
        '${url}user/confirm-password',
        body,
        // headers: getHeader(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<Map> socialLogin(Map body) async {
    Map repsResult = {};
    try {
      Response response = await post(
        '${apiUrl}socialLogin',
        body,
      );

      var responseBody = response.body;

      repsResult = responseBody;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      callFunctions.showFlush(defaultError);
    }
    return repsResult;
  }
}
