// import 'package:flutter/foundation.dart';
// import 'package:forex_guru/utils/strings.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// abstract class BaseOneSIgnalNotify {
//   Future<bool> createUserNotificationToken();
//   Future<bool> sendNotification(String heading, String content,
//       {List<OSActionButton>? buttons});
// }

// class OneSignalNotify implements BaseOneSIgnalNotify {
//   @override
//   Future<bool> createUserNotificationToken() async {
//     try {
//       String externalUserId = randomString(12);
//       OneSignal.shared.setExternalUserId(externalUserId);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//     return true;
//   }

//   @override
//   Future<bool> sendNotification(String heading, String content,
//       {List<OSActionButton>? buttons}) async {
//     try {
//       var deviceState = await OneSignal.shared.getDeviceState();

//       if (deviceState == null || deviceState.userId == null) {
//       } else {
//         var playerId = deviceState.userId!;

//         var notification = OSCreateNotification(
//           playerIds: [playerId],
//           heading: heading,
//           content: content,
//           buttons: buttons,
//         );

//         await OneSignal.shared.postNotification(notification);
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }

//     return true;
//   }
// }
