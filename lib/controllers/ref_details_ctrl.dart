import 'package:forex_guru/utils/strings.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../backends/all_repos.dart';

class RefDetailsCtrl extends GetxController {
  late Map future;
  static var usersBx = Hive.box(users);

  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    getUserRefDetails();
  }

  getUserRefDetails() async {
    future = await _allRepos.getUserRefDetails();
    if (future != {}) {
      usersBx.put('refDetails', future);
    }
  }
}
