// get all

// add new

// delete

// update (maybe)

//
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BasePayoutMethodApi {
  Future<List> getAllPayoutMethods();
  Future<bool> addNewPayoutMethod(Map data);
  Future<bool> updatePayoutMethod(Map data);
  Future<bool> deletePayoutMethod(String ref);
}

class PayoutMethodsApi extends GetConnect implements BasePayoutMethodApi {
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
  Future<bool> addNewPayoutMethod(Map data) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${apiUrl}payouts',
        data,
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
  Future<bool> deletePayoutMethod(String id) async {
    bool resStatus = false;

    try {
      Response response = await delete(
        '${apiUrl}payouts/$id',
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
  Future<bool> updatePayoutMethod(Map data) async {
    bool resStatus = false;
    try {
      String id = data['id'];
      Response response = await put(
        '${apiUrl}payouts/$id',
        data,
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
  Future<List> getAllPayoutMethods() async {
    List allPayoutMethods = [];
    try {
      Response response = await get(
        '${apiUrl}payouts',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allPayoutMethods = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allPayoutMethods;
  }
}
