// // get all

// // delete

// // update settings

// import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:forex_guru/backends/call_functions.dart';
// import 'package:forex_guru/utils/strings.dart';
// import 'package:get/get_connect/connect.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// abstract class BaseNotificationApi {
//   Future<List> getAllNotifications();
//   Future<bool> deleteNotification(String ref, context);
//   Future<Map> getNotificationsSettings();
//   // Future<bool> updateNotificationSettings(Map body, context);
// }

// class NotificationApi extends GetConnect implements BaseNotificationApi {
//   CallFunctions callFunctions = CallFunctions();
//   final _box = Hive.box(users);
//   String url = dotenv.env['ENDPOINT_URL_API']!;

//   Map<String, String> getHeader() {
//     String accessToken = _box.get('accessToken');
//     return {
//       'Content-type': 'application/json',
//       "Authorization": "Bearer $accessToken"
//     };
//   }

//   @override
//   Future<bool> deleteNotification(String ref, context) async {
//     bool resStatus = false;
//     try {
//       Response response = await delete(
//         '${url}notifications/$ref',
//         headers: getHeader(),
//       );

//       var responseBody = response.body;

//       if (responseBody[status]) {
//         String resMessage = responseBody[message];
//         callFunctions.showFlush(resMessage, context);
//       } else {
//         String errorMessage = responseBody[message];
//         callFunctions.showFlush(errorMessage, context);
//       }
//       resStatus = responseBody[status];
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }

//     return resStatus;
//   }

//   // @override
//   // Future<bool> updateNotificationSettings(Map body, context) async {
//   //   bool resStatus = false;
//   //   try {
//   //     Response response = await put(
//   //       '${url}user_config',
//   //       body,
//   //       headers: getHeader(),
//   //     );

//   //     var responseBody = response.body;

//   //     if (responseBody[status]) {
//   //       String resMessage = responseBody[message];
//   //       callFunctions.showFlush(resMessage, context);
//   //     } else {
//   //       String errorMessage = responseBody[message];
//   //       callFunctions.showFlush(errorMessage, context);
//   //     }
//   //     resStatus = responseBody[status];
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print(e);
//   //     }
//   //   }

//   //   return resStatus;
//   // }

//   @override
//   Future<List> getAllNotifications() async {
//     List allNotifications = [];
//     try {
//       Response response = await get(
//         '${url}notifications',
//         headers: getHeader(),
//       );

//       var body = response.body;

//       if (body[status]) {
//         allNotifications = body[message];
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }

//     return allNotifications;
//   }

//   @override
//   Future<Map> getNotificationsSettings() async {
//     Map notificationSettings = {};
//     try {
//       Response response = await get(
//         '${url}user_config',
//         headers: getHeader(),
//       );

//       var body = response.body;

//       if (body[status]) {
//         notificationSettings = body[message];

//         _box.put(userConfig, notificationSettings);
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }

//     return notificationSettings;
//   }
// }
