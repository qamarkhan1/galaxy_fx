import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/notification_ctrl.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_tile.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationScreen extends GetView {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    final NotificationController notificationController =
        Get.put(NotificationController());

    var box = Hive.box(users);
    var userSettings = box.get(userNotify) ?? {};

    Get.find<NotificationController>().loginMailStatus.value =
        userSettings['login_mail'] == null || userSettings['login_mail'] == '1'
            ? true
            : false;
    Get.find<NotificationController>().loginPushStatus.value =
        userSettings['login_push'] == null || userSettings['login_push'] == '1'
            ? true
            : false;

    Get.find<NotificationController>().trxnMailStatus.value =
        userSettings['trxn_mail'] == null || userSettings['trxn_mail'] == '1'
            ? true
            : false;
    Get.find<NotificationController>().trxnPushStatus.value =
        userSettings['trxn_push'] == null || userSettings['trxn_push'] == '1'
            ? true
            : false;
    return CustScaffold(
      title: '',
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
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
                          Text(
                            'Login Alerts',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          CustTile(
                            title: 'Email',
                            trailing: allRepos.toggleSwitch(
                                notificationController.loginMailStatus.value,
                                (bool val) {
                              notificationController.loginMailStatusFxn(val);
                            }),
                          ),
                          CustTile(
                            title: 'Push Notifications',
                            trailing: allRepos.toggleSwitch(
                                notificationController.loginPushStatus.value,
                                (bool val) {
                              notificationController.loginPushStatusFxn(val);
                            }),
                          ),
                          const Divider(
                            height: 30,
                          ),
                          Text(
                            'Transaction Alerts',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          CustTile(
                            title: 'Email',
                            trailing: allRepos.toggleSwitch(
                                notificationController.trxnMailStatus.value,
                                (bool val) {
                              notificationController.trxnMailStatusFxn(val);
                            }),
                          ),
                          CustTile(
                            title: 'Push Notifications',
                            trailing: allRepos.toggleSwitch(
                                notificationController.trxnPushStatus.value,
                                (bool val) {
                              notificationController.trxnPushStatusFxn(val);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                CustButton(
                  onTap: () async {
                    Map body = {
                      'login_mail': notificationController.loginMailStatus.value
                          ? '1'
                          : '0',
                      'login_push': notificationController.loginPushStatus.value
                          ? '1'
                          : '0',
                      'trxn_mail': notificationController.trxnMailStatus.value
                          ? '1'
                          : '0',
                      'trxn_push': notificationController.trxnPushStatus.value
                          ? '1'
                          : '0',
                    };
                    await allRepos.updateNotificationStatus(body);
                  },
                  title: 'Save Changes',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
