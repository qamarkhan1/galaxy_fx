import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../backends/all_repos.dart';

class SignalsCtrl extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  late Future<Map> future;

  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    controller = TabController(length: 2, vsync: this);
    getSignals();
    loadMore(true);
    loadMorePaid(true);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  getSignals() {
    future = _allRepos.getAllSignals();
  }

  final lData = [].obs;
  final lDataPaid = [].obs;
  final isLoading = false.obs;
  final currentLength = 0.obs;
  final currentLengthPaid = 0.obs;
  final int increment = 10;

  Future loadMore(bool isInit) async {
    isLoading(true);

    await Future.delayed(Duration(seconds: isInit ? 0 : 2));
    for (var i = currentLength.value;
        i <= currentLength.value + increment;
        i++) {
      lData.add(i);
    }

    isLoading(false);
    currentLength(lData.length);
  }

  Future loadMorePaid(bool isInit) async {
    isLoading(true);

    await Future.delayed(Duration(seconds: isInit ? 0 : 2));
    for (var i = currentLengthPaid.value;
        i <= currentLengthPaid.value + increment;
        i++) {
      lDataPaid.add(i);
    }

    isLoading(false);
    currentLengthPaid(lDataPaid.length);
  }
}
