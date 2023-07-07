// Get Plans

// get history

// Purchase plan

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseInvestmentApi {
  Future<Map> getAllInvestments();
  Future<List> getAllInvestmentHistory();
  Future<bool> makeInvest(Map body);
}

class InvestmentApi extends GetConnect implements BaseInvestmentApi {
  CallFunctions callFunctions = CallFunctions();
  final _box = Hive.box(users);
  String apiUrl = dotenv.env['ENDPOINT_URL_API']!;

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  Future<Map> getAllInvestments() async {
    Map allInvestPlans = {};
    try {
      Response response = await get(
        '${apiUrl}investments/plans',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allInvestPlans = body;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allInvestPlans;
  }

  @override
  Future<List> getAllInvestmentHistory() async {
    List allInvestInterestHistory = [];
    // Map allInvestHistory = {};
    try {
      Response investResponse = await get(
        '${apiUrl}investments/history',
        headers: getHeader(),
      );

      var investBody = investResponse.body;

      if (investBody[status]) {
        List allInvestHistory = investBody['investmentHistory'];
        List allInterestHistory = investBody['interestHistory'];
        allInvestInterestHistory = allInvestHistory + allInterestHistory;

        allInvestInterestHistory
            .sort((a, b) => b['created_at'].compareTo(a['created_at']));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allInvestInterestHistory;
  }

  @override
  Future<bool> makeInvest(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${apiUrl}investments',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        String resMessage = responseBody[message];
        Get.back();
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
}
