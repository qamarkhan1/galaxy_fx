// Plans

// History

// Purchase Plan

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseSubscriptionApi {
  Future<Map> getAllSubPlans();
  Future<Map> getUserSubHistory();
  Future<bool> subscribe(Map body);
}

class SubscriptionApi extends GetConnect implements BaseSubscriptionApi {
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
  Future<Map> getAllSubPlans() async {
    Map allSubscriptionPlans = {};
    try {
      Response response = await get(
        '${url}subscriptions/plans',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allSubscriptionPlans = body;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allSubscriptionPlans;
  }

  @override
  Future<Map> getUserSubHistory() async {
    Map allSubscriptionHistory = {};
    try {
      Response response = await get(
        '${url}subscriptions/history',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allSubscriptionHistory = body;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allSubscriptionHistory;
  }

  @override
  Future<bool> subscribe(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${url}subscriptions',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;
      if (responseBody[status]) {
        Get.back();
        String resMessage = responseBody[message];
        callFunctions.showFlush(resMessage, backgroundColor: green);
        resStatus = responseBody[status];
      } else {
        Get.back();
        String errorMessage = responseBody[message];
        callFunctions.showFlush(errorMessage, backgroundColor: red);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resStatus;
  }
}
