// get Signals

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseSignalsApi {
  Future<Map> getAllSignals();
}

class SignalsApi extends GetConnect implements BaseSignalsApi {
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
  Future<Map> getAllSignals() async {
    Map allSignals = {};
    try {
      Response response = await get(
        '${url}app_signals',
        headers: getHeader(),
      );

      var body = response.body;
      if (body[status]) {
        allSignals = body;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allSignals;
  }
}
