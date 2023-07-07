import 'package:get/state_manager.dart';

import '../backends/all_repos.dart';

class RefPayoutsCtrl extends GetxController {
  late Future<List> future;

  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    getUserRefEarningsAndPayoutsHistory();
    loadMore(true);
  }

  getUserRefEarningsAndPayoutsHistory() {
    future = _allRepos.getUserRefEarningsAndPayoutsHistory();
  }

  final lData = [].obs;
  final isLoading = false.obs;
  final currentLength = 0.obs;
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
}
