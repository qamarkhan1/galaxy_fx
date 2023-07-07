// get All

// Add new

// Delete

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_guru/backends/call_functions.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseDevicesApi {
  Future<List> getAllDevices();
  Future<bool> storeNewDevice();
  Future<bool> deleteDeviceHistory(String ref);
}

class DevicesApi extends GetConnect implements BaseDevicesApi {
  String? ipGeoKey = dotenv.env['IP_GEOLOCATION_KEY'];
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
  Future<bool> deleteDeviceHistory(String ref) async {
    bool resStatus = false;
    try {
      Response response = await delete(
        '${apiUrl}devices/$ref',
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
  Future<List> getAllDevices() async {
    List allDevices = [];
    try {
      Response response = await get(
        '${apiUrl}devices',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allDevices = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allDevices;
  }

  @override
  Future<bool> storeNewDevice() async {
    bool resStatus = false;
    try {
      Map<String, dynamic> dats = {};
      String? device = await getDeviceInfo();
      Map<String, dynamic>? deviceIp = await getIp();

      deviceIp[deviceName] = device;
      deviceIp[platform] = mobile;
      dats = deviceIp;

      Response response = await post(
        '${apiUrl}devices',
        dats,
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

  Future<String?> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceName;
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo? androidInfo = await deviceInfo.androidInfo;

        deviceName = androidInfo.model;
        return deviceName;
      }
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      deviceName = iosInfo.name;
      return deviceName;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return deviceName;
  }

  Future<Map<String, dynamic>> getIp() async {
    Map<String, dynamic> dts = {};

    String url = 'https://api.ipgeolocation.io/ipgeo?apiKey=$ipGeoKey';
    try {
      Response response = await get(url);
      var data = response.body;
      dts = {
        ip: data[ip],
        location: data["district"] + ", " + data["city"],
        country: data["country_name"],
      };
      return dts;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return dts;
  }
}
