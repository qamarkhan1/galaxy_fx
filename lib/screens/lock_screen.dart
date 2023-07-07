import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/screens/home.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

AllRepos _allRepos = AllRepos();

class _LockScreenState extends State<LockScreen> {
  int index = 0;

  static var settingsBx = Hive.box(settings);
  static var lockPinBx = settingsBx.get(lockPin);
  String? currentPin = lockPinBx;
  static var authBx = settingsBx.get(authConfig);

  var biometricsAuth = authBx['biometrics'] ?? false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(
        width: double.infinity,
        child: IndexedStack(
          index: index,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnalogClock(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      shape: BoxShape.circle,
                    ),
                    width: 200.0,
                    height: 200.0,
                    textScaleFactor: 1.2,
                    datetime: DateTime.now(),
                    isLive: true,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index++;
                        });
                      },
                      child: Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: black,
                            highlightColor: grey,
                            child: const CircleAvatar(
                              radius: 30,
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: transparent,
                            child: Icon(
                              Feather.lock,
                              size: 30,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ScreenLock(
              correctString: currentPin!,
              onUnlocked: () {
                Get.to(
                  const HomePage(),
                );
              },
              onCancelled: () {
                index--;
                setState(() {});
              },
              customizedButtonChild: biometricsAuth
                  ? Icon(
                      Icons.fingerprint,
                      color: white,
                    )
                  : null,
              useLandscape: false,
              customizedButtonTap: biometricsAuth
                  ? () async => await _allRepos.authenticate()
                  : null,
              onOpened: biometricsAuth
                  ? () async => await _allRepos.authenticate()
                  : null,
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
            ),
          ],
        ),
      ),
    );
  }
}
