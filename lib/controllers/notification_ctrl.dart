import 'package:forex_guru/backends/all_repos.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final loginMailStatus = true.obs;

  final loginPushStatus = true.obs;

  final trxnMailStatus = true.obs;

  final trxnPushStatus = true.obs;

  void loginMailStatusFxn(bool isActive) {
    loginMailStatus(isActive);
  }

  void loginPushStatusFxn(bool isActive) {
    loginPushStatus(isActive);
  }

  void trxnMailStatusFxn(bool isActive) {
    trxnMailStatus(isActive);
  }

  void trxnPushStatusFxn(bool isActive) {
    trxnPushStatus(isActive);
  }

  late Future<List> future;
  final AllRepos _allRepos = AllRepos();

  @override
  void onInit() {
    super.onInit();
    getAllNotifications();
    loadMore(true);
  }

  getAllNotifications() {
    future = _allRepos.getAllNotifications();
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
