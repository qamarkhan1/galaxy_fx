import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Get Plans

// get history

// Enroll

abstract class BaseClassesApi {
  Future<Map> getAllClasses();
  Future<List> getClassesContents(String ref);
  Future<List> getUserClasses();
  Future<bool> enroll(Map body);
  Future<bool> rateCourse(Map body);
}

class ClassesApi extends GetConnect implements BaseClassesApi {
  String apiUrl = dotenv.env['ENDPOINT_URL_API']!;
  final _box = Hive.box(users);
  CallFunctions callFunctions = CallFunctions();

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  Future<bool> enroll(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${apiUrl}app_classes',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;

      if (responseBody[status]) {
        Get.back();
        String resMessage = responseBody[message];
        callFunctions.showFlush(
          resMessage,
          backgroundColor: green,
        );
      } else {
        Get.back();

        String errorMessage = responseBody[message];
        callFunctions.showFlush(
          errorMessage,
          backgroundColor: red,
        );
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
  Future<Map> getAllClasses() async {
    Map allClasses = {};
    try {
      Response response = await get(
        '${apiUrl}app_classes',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allClasses = body;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allClasses;
  }

  @override
  Future<List> getClassesContents(String ref) async {
    List classContents = [];
    try {
      Response response = await get(
        '${apiUrl}app_classes/$ref',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        classContents = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return classContents;
  }

  @override
  Future<List> getUserClasses() async {
    List userClassHist = [];
    try {
      Response response = await get(
        '${apiUrl}app_classes',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        userClassHist = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return userClassHist;
  }

  @override
  Future<bool> rateCourse(Map body) async {
    bool resStatus = false;
    try {
      Response response = await post(
        '${apiUrl}classes-ratings',
        body,
        headers: getHeader(),
      );

      var responseBody = response.body;
      if (responseBody[status]) {
        Get.back();
        String resMessage = responseBody[message];
        callFunctions.showFlush(
          resMessage,
          backgroundColor: green,
        );
      } else {
        Get.back();

        String errorMessage = responseBody[message];
        callFunctions.showFlush(
          errorMessage,
          backgroundColor: red,
        );
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
