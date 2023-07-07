import 'package:flutter/material.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangePinCtrl extends GetxController {
  final focusNode = FocusNode();
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final newIndex = 0.obs;

  final activatePin = true.obs;

  final box = Hive.box(users);
  final settingsBx = Hive.box(settings);

  final inputPin = ''.obs;
  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  setInputPin(String val) {
    inputPin(val);
  }

  setActivePin(bool val) {
    activatePin(val);
    settingsBx.put(activePinCode, val);
  }

  void changeIndex(bool isAdd, int index) {
    if (isAdd) {
      newIndex(index + 1);
      pinController.clear();
    } else {
      newIndex(index - 1);
    }
  }
}
