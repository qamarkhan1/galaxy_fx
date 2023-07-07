// Deposit

// Withdraw

// get Transaction hsitories
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

abstract class BaseTransactionsApi {
  Future<List> getAllTransactions();
  Future<bool> depositFxn(Map body);
  Future<bool> withdrawFxn(Map body);
}

class TransactionsApi extends GetConnect implements BaseTransactionsApi {
  CallFunctions callFunctions = CallFunctions();
  static final _box = Hive.box(users);
  String url = dotenv.env['ENDPOINT_URL_API']!;

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');

    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  Future<List> getAllTransactions() async {
    List allTransactions = [];
    try {
      Response response = await get(
        '${url}transactions',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allTransactions = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allTransactions;
  }

  @override
  Future<bool> depositFxn(Map body) async {
    bool resStatus = false;
    try {
      String accessToken = _box.get('accessToken');

      String uri = '${url}transactions';

      if (body['payment_method'] == bank) {
        var request = http.MultipartRequest('POST', Uri.parse(uri));

        String header = "Bearer $accessToken";
        request.headers['Authorization'] = header;

        request.fields['payment_method'] = bank;
        request.fields['amount'] = body['amount'];
        request.fields['trnx_type'] = deposit;

        File file = File(body['receipt']);
        request.files.add(
          http.MultipartFile(
              'image', file.readAsBytes().asStream(), file.lengthSync(),
              filename: file.path.split('/').last),
        );

        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        var resBody = jsonDecode(respStr);

        if (resBody[status]) {
          resStatus = true;
          callFunctions.showFlush(resBody[message], success: true);

          return true;
        } else {
          callFunctions.showFlush(resBody[message], success: false);

          return false;
        }
      } else {
        Response response = await post(uri, body, headers: getHeader());

        var responseBody = response.body;
        if (responseBody[status]) {
          String resMessage = responseBody[message];
          callFunctions.showFlush(resMessage, success: true);
        } else {
          String errorMessage = responseBody[message];
          callFunctions.showFlush(errorMessage, success: false);
        }
        resStatus = responseBody[status];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      callFunctions.showFlush(defaultError, success: false);
    }

    return resStatus;
  }

  Future<http.StreamedResponse> updateProfile(String pickedPath) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('${url}upload'));
    if (pickedPath.isNotEmpty) {
      File file = File(pickedPath);
      request.files.add(
        http.MultipartFile(
            'image', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last),
      );
    }
    // Map<String, String> fields = Map();
    // fields.addAll(<String, String>{
    //   'f_name': userInfoModel.fName,
    //   'email': userInfoModel.email
    // });
    // request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  @override
  Future<bool> withdrawFxn(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${url}transactions',
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
      callFunctions.showFlush(defaultError, success: false);
    }

    return resStatus;
  }
}
