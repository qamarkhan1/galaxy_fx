import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/auth_screen_ctrl.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../utils/config.dart';
import '../../utils/strings.dart';
import '../../widgets/cust_tile.dart';

class AuthScreen extends GetView {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    final AuthController authController = Get.put(AuthController());
    var settingsBx = Hive.box(settings);
    var bx = settingsBx.get(authConfig);

    Get.find<AuthController>().biometricsStatus.value =
        bx != null ? bx['biometrics'] : true;
    Get.find<AuthController>().trxnAuthStatus.value =
        bx != null ? bx['trxn_auth'] : true;
    return CustScaffold(
      title: '',
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Use Auth',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustTile(
                          title: 'Biometrics',
                          trailing: allRepos.toggleSwitch(
                              Get.find<AuthController>().biometricsStatus.value,
                              (bool val) {
                            authController.biometricsStatusFxn(val);
                          }),
                        ),
                        CustTile(
                          title: 'Transaction Auth',
                          trailing: allRepos.toggleSwitch(
                              Get.find<AuthController>().trxnAuthStatus.value,
                              (bool val) {
                            authController.trxnAuthStatusFxn(val);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              CustButton(
                onTap: () {
                  try {
                    Map data = {
                      'biometrics': authController.biometricsStatus.value,
                      'trxn_auth': authController.trxnAuthStatus.value,
                    };
                    settingsBx.put(authConfig, data).then((value) {
                      allRepos.showFlush('Auth settings Updated',
                          success: true);
                    });
                  } catch (e) {
                    allRepos.showFlush(
                      defaultError,
                    );
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                title: 'Save Changes',
              ),
            ],
          ),
        ),
      )),
    );
  }
}
