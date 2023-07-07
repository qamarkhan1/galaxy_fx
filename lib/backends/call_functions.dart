import 'dart:io';

import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';
import '../widgets/cust_prog_ind.dart';
import '../widgets/empty.dart';

abstract class BaseFunction {
  launchUrlFxn(String url);
  showSnacky(
    String msg,
    bool isSuccess, {
    Map<String, String>? args,
    String extra2,
    String? title,
  });

  toggleSwitch(
    bool value,
    Function(bool) onChanged,
  );

  showPicker(
    context, {
    List<dynamic>? children,
    Function(int?)? onSelectedItemChanged,
    Function(String?)? onChanged,
    bool hasTrns = true,
  });

  showPopUp(
    Widget content,
    List<CupertinoButton> iosActions,
    // Function()? onConfirmm,

    List<TextButton> androidActions, {
    IconData icon,
    String msg,
    Color color,
    bool barrierDismissible = true,
    Function()? onCancel,
  });

  showModalBarAction(
    Widget child,
    List<CupertinoActionSheetAction> action,
  );
  showModalBar(
    Widget content, {
    bool isDismissible,
  });

  showFlush(
    String message, {
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    bool? success,
  });
  snapshotFuture(
    AsyncSnapshot<dynamic> snapshot,
    Widget widget, {
    double? height = 0.0,
    bool hasBack = true,
    Widget customEmpty,
  });
  String avatarManipulation(String name);

  String getNewDate(String date);
  customDialog(Widget child);
  cronJob(Function function, int when);

  // String? translation(context, String key, {Map<String, String>? args});
  // String? multiTranslation(Get.overlayContext!, List<String> keys,
  //     {Map<String, String>? args});
}

class CallFunctions implements BaseFunction {
  final cron = Cron();

  @override
  launchUrlFxn(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch $url';
  }

  @override
  showSnacky(
    String msg,
    bool isSuccess, {
    Map<String, String>? args,
    String extra2 = "",
    String? title,
  }) {
    Get.snackbar(
      title!,
      // TrnsText(title: msg, extra2: extra2, args: args),
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isSuccess ? green : primaryColor,
    );
  }

  @override
  toggleSwitch(
    bool value,
    Function(bool) onChanged,
  ) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        activeColor: primaryColor,
        value: value,
        onChanged: onChanged,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: white,
      );
    }
  }

  @override
  showPicker(context,
      {List<dynamic>? children,
      Function(int?)? onSelectedItemChanged,
      Function(String?)? onChanged,
      bool hasTrns = true}) {
    Platform.isIOS
        ? showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: CupertinoPicker(
                  useMagnifier: true,
                  magnification: 1.3,
                  onSelectedItemChanged: onSelectedItemChanged,
                  itemExtent: 32.0,
                  children: children!.map((value) {
                    return hasTrns
                        ? Text(
                            value!,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          )
                        : Text(
                            value.toUpperCase(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          );
                  }).toList(),
                ),
              );
            })
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 200,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: const Icon(Ionicons.ios_arrow_down),
                    underline: Container(),
                    hint: const Text('Select'),
                    items: children!.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: hasTrns
                            ? Text(value!)
                            : Text(
                                value.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          );
  }

  @override
  showModalBarAction(
    Widget child,
    List<CupertinoActionSheetAction> action,
  ) {
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: Get.overlayContext!,
            builder: (BuildContext context) => CupertinoActionSheet(
              actions: action,
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          )
        : showModalBottomSheet(
            context: Get.overlayContext!, builder: (_) => child);
  }

  @override
  showFlush(
    String message, {
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    bool? success,
  }) {
    Flushbar(
      backgroundColor: success == null
          ? (backgroundColor ?? amber)
          : (success ? green : red),
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      icon: Icon(
        success == null
            ? (icon ?? IconlyLight.infoSquare)
            : (success ? IconlyLight.tickSquare : IconlyLight.closeSquare),
        size: 28.0,
        color: iconColor ?? white,
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      // backgroundColor: backgroundColor ?? accent,
    ).show(Get.overlayContext!);
  }

  @override
  showPopUp(
    Widget content,
    List<CupertinoButton> iosActions,
    // Function()? onConfirmm,

    List<TextButton> androidActions, {
    String? msg,
    IconData? icon,
    Color? color,
    bool barrierDismissible = true,
    Function()? onCancel,
  }) {
    // Get.defaultDialog(
    //   title: 'GetX Alert',
    //   middleText: 'Simple GetX alert',
    //   textConfirm: 'Okay',
    //   confirmTextColor: Colors.white,
    //   textCancel: 'Cancel',
    //   onCancel: onCancel,
    //   onConfirm: onConfirmm,
    //   // actions: iosActions,
    // );

    Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: barrierDismissible,
            context: Get.overlayContext!,
            builder: (_) => CupertinoAlertDialog(
              content: content,
              title: icon != null
                  ? Icon(
                      icon,
                      color: color,
                      size: 30,
                    )
                  : msg != null
                      ? Text(
                          msg,
                          style: TextStyle(color: color),
                        )
                      : null,
              actions: iosActions,
            ),
          )
        : showDialog(
            barrierDismissible: barrierDismissible,
            context: Get.overlayContext!,
            builder: (_) => AlertDialog(
              content: content,
              title: icon != null
                  ? Icon(
                      icon,
                      color: color,
                      size: 30,
                    )
                  : msg != null
                      ? Text(
                          msg,
                          style: TextStyle(color: color),
                        )
                      : null,
              actions: androidActions,
            ),
          );
  }

  @override
  showModalBar(
    Widget content, {
    bool? isDismissible,
  }) {
    Get.bottomSheet(
      Material(
        // color: white,
        child: content,
      ),
      isDismissible: isDismissible ?? true,
      isScrollControlled: true,
    );
    // Platform.isIOS
    //     ? showCupertinoModalBottomSheet(
    //         isDismissible: isDismissible ?? true,
    //         context: Get.overlayContext!,
    //         builder: (_) => Material(
    //           color: Theme.of(context).scaffoldBackgroundColor,
    //           child: content,
    //         ),
    //       )
    //     : showModalBottomSheet(
    //         isScrollControlled: true,
    //         isDismissible: isDismissible ?? true,
    //         context: Get.overlayContext!,
    //         builder: (_) => Material(
    //           color: Theme.of(context).scaffoldBackgroundColor,
    //           child: content,
    //         ),
    //       );
  }

  @override
  snapshotFuture(
    AsyncSnapshot<dynamic>? snapshot,
    Widget widget, {
    double? height = 0.0,
    bool hasBack = true,
    Widget? customEmpty,
  }) {
    try {
      if (snapshot!.connectionState == ConnectionState.waiting) {
        return const CustProgIndicator();
      } else if (snapshot.hasError) {
        return Column(
          children: [
            SizedBox(height: height),
            EmptyWid(
              svg: 'error',
              title: 'Error Occurred',
              subtitle: 'Ouch, we hit an error!',
              hasBack: hasBack,
            ),
          ],
        );
      } else if (!snapshot.hasData ||
          snapshot.data == null ||
          snapshot.data.isEmpty) {
        return Column(
          children: [
            SizedBox(height: height),
            customEmpty ??
                EmptyWid(
                  svg: 'empty',
                  title: 'Nothing Found',
                  subtitle: 'Oh No, seems nothing was found here',
                  hasBack: hasBack,
                )
          ],
        );
      } else {
        return widget;
      }
    } catch (e) {
      return Column(
        children: [
          SizedBox(height: height),
          EmptyWid(
            svg: 'error',
            title: 'Error Occurred',
            subtitle: 'Ouch, we hit an error!',
            hasBack: hasBack,
          ),
        ],
      );
    }
  }

  @override
  String avatarManipulation(String name) {
    String avatar = '';
    try {
      List<String> parts = name.trim().split(' ');

      List<String> cleanParts = [];
      for (String part in parts) {
        if (part.trim().isNotEmpty) {
          cleanParts.add(part);
        }
      }
      if (cleanParts.length > 1) {
        avatar = cleanParts[0].trim().substring(0, 1) +
            cleanParts[1].replaceAll(' ', '').substring(0, 1).trim();
      } else {
        avatar = cleanParts[0].substring(0, 2);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return avatar;
  }

  @override
  String getNewDate(String date) {
    DateTime newDate = DateTime.parse(date);

    int mill = newDate.millisecondsSinceEpoch;

    DateFormat inputFormat = DateFormat('dd-MM-yyyy | HH:mm');
    String inputDate = inputFormat
        .format(DateTime.fromMillisecondsSinceEpoch(mill))
        .toString();

    return inputDate;
  }

  @override
  customDialog(Widget child) async {
    return showDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, dialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: child,
              );
            }));
  }

  @override
  cronJob(Function function, int when) {
    function();

    cron.schedule(Schedule.parse('*/$when * * * *'), () async {
      function();
    });
  }

  // @override
  // String? translation(context, String key, {Map<String, String>? args}) {
  //   return AppLocalizations.of(Get.overlayContext!)!.translate(key, args: args);
  // }

  // @override
  // String? multiTranslation(context, List<String> keys,
  //     {Map<String, String>? args}) {
  //   List strList = [];

  //   for (String key in keys) {
  //     String str = AppLocalizations.of(Get.overlayContext!)!.translate(key, args: args)!;

  //     strList.add(str);
  //   }
  //   return strList.join(' ');
  // }
}
