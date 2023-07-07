import 'dart:collection';
import 'dart:io';

import 'package:forex_guru/utils/strings.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:get/get.dart';

class StartPageCtrl extends GetxController {
  static var settingsBx = Hive.box(settings);

  final loading = false.obs;
  final checked = false.obs;
  final obscure = true.obs;

  @override
  void onInit() {
    super.onInit();
    storeIntroView();
    initPlatformState();
  }

  storeIntroView() {
    settingsBx.put('intro', true);
  }

  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#229954";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse(
          'torusapp://org.torusresearch.flutter.web3authexample/auth');
    } else if (Platform.isIOS) {
      redirectUrl =
          Uri.parse('torusapp://org.torusresearch.flutter.web3authexample');
    } else {
      throw UnKnownException('Unknown platform');
    }
    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            'BHZPoRIHdrfrdXj5E8G5Y72LGnh7L8UFuM8O0KrZSOs4T8lgiZnebB5Oc6cbgYSo3qSz7WBZXIs8fs6jgZqFFgw',
        network: Network.testnet,
        redirectUrl: redirectUrl,
      ),
    );
  }

  void loadingFxn(bool isActive) {
    loading(isActive);
  }

  void checkFxn(bool isActive) {
    checked(isActive);
  }

  void obscureFxn(bool isActive) {
    obscure(isActive);
  }
}
