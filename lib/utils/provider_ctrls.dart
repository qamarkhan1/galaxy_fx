import 'package:flutter/material.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProviderControllers with ChangeNotifier {
  // static bool _isDark = true;
  static String _themeMode = system;
  static String? _locale = "en";
  // static Locale? _locale = Locale("en", "US");
  var settingsBx = Hive.box(settings);

  ProviderControllers() {
    if (settingsBx.containsKey(theme)) {
      _themeMode = settingsBx.get(theme);
    } else {
      settingsBx.put(theme, _themeMode);
    }
  }

  ThemeMode currentTheme() {
    return themeSwitchCases(getFxn(theme, system));
  }

  themeSwitchCases(String mode) {
    switch (mode) {
      case system:
        return ThemeMode.system;
      case light:
        return ThemeMode.light;
      case dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void switchTheme(String mode) {
    // _isDark = !_isDark;
    putFxn(theme, mode);
    notifyListeners();
  }

  void onLanguageChange() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    notifyListeners();
  }

  setLocale(int languageCode) async {
    _locale = languaeCodes[languageCode];
    putFxn("lang", _locale);
    notifyListeners();
  }

  String getLocale() {
    return getFxn("lang", "en");
  }

  getFxn(key, def) {
    return settingsBx.get(key) ?? def;
  }

  putFxn(key, value) {
    settingsBx.put(key, value);
  }
}
