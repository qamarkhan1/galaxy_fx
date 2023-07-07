import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../utils/strings.dart';

abstract class BaseMiscApi {
  Future<void> getMore();
}

class MiscApi extends GetConnect implements BaseMiscApi {
  CallFunctions callFunctions = CallFunctions();
  final _box = Hive.box(users);
  final settingsBx = Hive.box(settings);

  String apiUrl = dotenv.env['ENDPOINT_URL_API']!;

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  getMore() async {
    try {
      Response response = await get(
        '${apiUrl}admin-configs',
        // headers: getHeader(),
      );
      var body = response.body;

      if (body[status]) {
        List list = body[message];

        Map result = {};

        for (var element in list) {
          Map val = {
            element['title']: element['value'],
          };
          result.addAll(val);
        }
        settingsBx.put(more, result);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
