import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:local_auth/local_auth.dart';

abstract class BaseBio {
  Future<bool?> checkAvailability();
  Future<String?> getAvailableBiometric();
  Future<bool?> authenticate();
}

class BiometricsFxn implements BaseBio {
  var localAuth = LocalAuthentication();

  @override
  Future<bool?> checkAvailability() async {
    bool? canCheckBiometrics;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return canCheckBiometrics;
  }

  @override
  Future<bool?> authenticate() async {
    bool? didAuthenticate;
    try {
      // const iosStrings = const IOSAuthMessages(
      //   cancelButton: 'cancel',
      //   goToSettingsButton: 'settings',
      //   goToSettingsDescription: 'settings',
      //   lockOut: 'Please re-enable your Biometrics',
      // );
      didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate',
        authMessages: {},
        options: const AuthenticationOptions(
          useErrorDialogs: false,
        ),
        // iOSAuthStrings: iosStrings,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return didAuthenticate;
  }

  @override
  Future<String?> getAvailableBiometric() async {
    String? bioType;
    try {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          bioType = face;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          bioType = touchId;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return bioType;
  }
}
