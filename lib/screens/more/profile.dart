import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/avatar_wid.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_tile.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileScreen extends GetView {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(users);
    AllRepos allRepos = AllRepos();
    Map userProfile = box.get('userProfile') ?? {};
    String name = userProfile['name'] ?? "";
    String email = userProfile['email'] ?? "";
    int id = email.hashCode;
    String createdAt = userProfile['created_at'] ?? "";

    String newDate = allRepos.getNewDate(createdAt);
    Size med = MediaQuery.of(context).size;

    return CustScaffold(
      title: '',
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: SizedBox(
            height: med.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(email),
                      trailing: AvatarWidget(name: name),
                    ),
                    const SizedBox(height: 30),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          'ACCOUNT',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Card(
                          elevation: 0.2,
                          child: Column(
                            children: [
                              CustTile(
                                title: 'ID',
                                trailing: Text('$id',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              CustTile(
                                title: 'Full Name',
                                trailing: Text(name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              CustTile(
                                title: 'Created Date',
                                trailing: Text(newDate,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => popWarning(allRepos),
                  child: Text('Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: red,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  popWarning(AllRepos allRepos) {
    allRepos.showModalBar(Container(
      height: 400,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Warning',
            style: Theme.of(Get.overlayContext!).textTheme.headline4,
          ),
          Text(
            'You are about to delete your account, be advised that this process is irreversible, and you will lose any funds attached to your account.',
            style: TextStyle(
              color: red,
            ),
          ),
          const SizedBox(height: 30),
          CustButton(
            onTap: () async {
              try {
                authWid(() async {
                  Get.back();
                  await allRepos.deleteAccount({});
                });
              } catch (e) {
                allRepos.showFlush(defaultError);
              }
            },
            title: 'I Know, Delete',
            color: red,
          ),
          const SizedBox(height: 10),
          CustButton(
            onTap: () => Get.back(),
            title: 'No, Cancel',
            isHollow: true,
          ),
        ],
      ),
    ));
  }

  authWid(Function() onUnlocked) {
    final settingsBx = Hive.box(settings);
    var lockPinBx = settingsBx.get(lockPin);
    String? currentPin = lockPinBx;
    var authBx = settingsBx.get(authConfig);
    AllRepos allRepos = AllRepos();

    var biometricsAuth = authBx['biometrics'] ?? false;
    allRepos.showModalBar(ScreenLock(
      correctString: currentPin!,
      onUnlocked: onUnlocked,
      onCancelled: () {
        Get.back();
      },
      customizedButtonChild: biometricsAuth
          ? Icon(
              Icons.fingerprint,
              color: white,
            )
          : null,
      useLandscape: false,
      customizedButtonTap:
          biometricsAuth ? () async => await allRepos.authenticate() : null,
      onOpened:
          biometricsAuth ? () async => await allRepos.authenticate() : null,
      cancelButton: Icon(
        Icons.close,
        color: white,
        size: 30,
      ),
      deleteButton: Icon(
        Icons.backspace,
        color: white,
        size: 30,
      ),
      config: ScreenLockConfig(
        backgroundColor: black,
      ),
      keyPadConfig: KeyPadConfig(
        buttonConfig: KeyPadButtonConfig(
          foregroundColor: white,
          buttonStyle: OutlinedButton.styleFrom(
            textStyle: TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      maxRetries: 5,
      retryDelay: const Duration(minutes: 1),
    ));
  }
}
