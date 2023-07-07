import '../backends/all_repos.dart';
import 'package:get/get.dart';

class FrontScreenCtrl extends GetxController {
  Map? future;
  final AllRepos _allRepos = AllRepos();
  final userBal = {}.obs;
  final showBal = true.obs;

  getWebView() async {
    future = await _allRepos.getUserData();
    if (future != null) {
      userBal.assignAll(future!['userBalance']);
    }
  }

  toggleBal(bool val) {
    showBal(val);
  }
}
