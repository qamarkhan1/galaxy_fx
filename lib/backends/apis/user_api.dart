// Get User Profile

// Balances

// Referral

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseUserApi {
  Future<Map> getUserData();
  Future<Map> getUserRefDetails();
  Future<bool> updateProfile(Map body);
  Future<List> getUserRefHistory();
  Future<List> getUserRefEarningsAndPayoutsHistory();
}

class UserApi extends GetConnect implements BaseUserApi {
  CallFunctions callFunctions = CallFunctions();
  final _box = Hive.box(users);
  String url = dotenv.env['ENDPOINT_URL_API']!;

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  Future<Map> getUserData() async {
    Map userData = {};
    try {
      Response response = await get(
        '${url}user/balances',
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        userData = responseBody;

        Map userProfile = userData['user'];
        Map userBalance = userData['userBalance'];
        _box.put('userProfile', userProfile);
        _box.put('userBalance', userBalance);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return userData;
  }

  @override
  Future<Map> getUserRefDetails() async {
    Map referral = {};
    try {
      Response response = await get(
        '${url}referral',
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        referral = responseBody[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return referral;
  }

  @override
  Future<bool> updateProfile(Map body) async {
    bool resStatus = false;
    try {
      Response response = await put(
        '${url}user',
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
  Future<List> getUserRefEarningsAndPayoutsHistory() async {
    List allUserRefEarningsPayouts = [];
    try {
      Response response = await get(
        '${url}referral/logs/payouts',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allUserRefEarningsPayouts = body['payouts'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allUserRefEarningsPayouts;
  }

  @override
  Future<List> getUserRefHistory() async {
    List allUserReferees = [];
    try {
      Response response = await get(
        '${url}referral/logs/history',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allUserReferees = body['history'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allUserReferees;
  }
}
