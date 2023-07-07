import 'package:get/get.dart';

class ChangePassCtrl extends GetxController {
  Map? future;

  final showCurrent = true.obs;
  final showNew = true.obs;

  toggleCurrent(bool val) {
    showCurrent(val);
  }

  toggleNew(bool val) {
    showNew(val);
  }
}
