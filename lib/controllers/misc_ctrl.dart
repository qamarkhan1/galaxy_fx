import 'package:get/state_manager.dart';

import '../backends/all_repos.dart';

class MiscCtrl extends GetxController {
  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    getMore();
  }

  getMore() async {
    await _allRepos.getMore();
  }
}
