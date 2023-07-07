import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:forex_guru/utils/strings.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../call_functions.dart';

abstract class BaseNotificationRepo {
  requestNotificationPermission();
  foregroundMessage();
  backgroundMessage();
  subscribeToTopics(String topic);
  unSubscribeFromTopics(String topic);
  Future<void> sendPushNotification(Map data);
  Future<void> sendEmailNotification(Map data);
  // Map getPushStatus();
  Future<void> getUserSettings();
  Future<bool> updateNotificationStatus(Map data);
  Future<List> getAllNotifications();
  Future<void> setupToken();
}

class NotificationRepo extends GetConnect implements BaseNotificationRepo {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  CallFunctions callFunctions = CallFunctions();

  static final _box = Hive.box(users);

  static final userSettings = _box.get(userNotify);
  String apiUrl = dotenv.env['ENDPOINT_URL_API']!;

  Map<String, String> getHeader() {
    String accessToken = _box.get('accessToken');
    return {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };
  }

  @override
  requestNotificationPermission() async {
    try {
      NotificationSettings settings = await messaging.requestPermission();
      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  foregroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
      }
      if (kDebugMode) {
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });
  }

  @override
  backgroundMessage() {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }

  @override
  subscribeToTopics(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  @override
  unSubscribeFromTopics(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  // @override
  // Map getPushStatus() {
  //   bool loginPush = userSettings['login_push'];
  //   bool trxnPush = userSettings['trxn_push'];
  //   Map data = {
  //     'login': loginPush,
  //     'trxn': trxnPush,
  //   };

  //   return data;
  // }

  @override
  Future<void> getUserSettings() async {
    try {
      Response response = await get(
        '${apiUrl}app-configs',
        headers: getHeader(),
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
        _box.put(userNotify, result);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<bool> updateNotificationStatus(Map data) async {
    bool resStatus = false;

    try {
      Map userConfig = _box.get(userNotify) ?? {};
      userConfig.addAll(data);

      List<Map> userConfigList = [];
      userConfig.entries.map((entry) {
        userConfigList.add({
          entry.key: entry.value,
        });
      }).toList();

      userConfig.entries.map((entry) async {
        Map data = {
          'title': entry.key,
          'value': entry.value,
        };

        await post(
          '${apiUrl}app-configs',
          data,
          headers: getHeader(),
        );
      }).toList();

      userConfig.addAll(data);

      _box.put(userNotify, userConfig);
      callFunctions.showFlush(success, success: true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      callFunctions.showFlush(defaultError, success: false);
    }
    return resStatus;
  }

  @override
  Future<void> sendPushNotification(Map data) async {
    try {
      await post(
        '${apiUrl}notifications',
        data,
        headers: getHeader(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<void> sendEmailNotification(Map data) async {
    try {
      if (data['isLogin']) {
        await post(
          '${apiUrl}login-mail',
          data,
          headers: getHeader(),
        );
      } else {
        await post(
          '${apiUrl}transaction-mail',
          data,
          headers: getHeader(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await messaging.getToken();
    Map data = {
      'device_key': token,
    };
    try {
      await post(
        '${apiUrl}notifications-tokens',
        data,
        headers: getHeader(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('e $e');
      }
    }
  }

  @override
  Future<List> getAllNotifications() async {
    List allNotifications = [];
    try {
      Response response = await get(
        '${apiUrl}notifications',
        headers: getHeader(),
      );

      var body = response.body;

      if (body[status]) {
        allNotifications = body[message];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return allNotifications;
  }
}
