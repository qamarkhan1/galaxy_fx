import 'package:forex_guru/utils/strings.dart';
import 'package:get/get.dart';
import '../backends/all_repos.dart';

class PayoutController extends GetxController {
  late Future<List> future;
  final AllRepos _allRepos = AllRepos();

  final newIndex = 0.obs;

  final activePaymethod = paypal.obs;

  void changeIndex(bool isAdd, int index) {
    if (isAdd) {
      newIndex(index + 1);
    } else {
      newIndex(index - 1);
    }
  }

  void setMethod(String currentMthod) {
    activePaymethod.value = currentMthod;
  }

  @override
  void onInit() {
    super.onInit();
    getPayoutMethods();
    loadMore(true);
  }

  getPayoutMethods() {
    future = _allRepos.getAllPayoutMethods();
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
