import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../backends/all_repos.dart';

class TwoFaCtrl extends GetxController {
  // late Future<Map> future;
  // late Future<bool> future2;

  final FocusNode focusNode = FocusNode();

  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    twoFAQRCode();
  }

  @override
  void onClose() {
    super.onClose();
    focusNode.dispose();
  }

  twoFAQRCode() {
    // future2 = _allRepos.twoFASet();
    // future =
    _allRepos.twoFAQRCode();
  }
}
