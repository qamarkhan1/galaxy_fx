import 'package:flutter/material.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsController extends GetxController {
  static final _box = Hive.box(settings);

  final _themKey = 'isDarkMode';
  // final _currencyKey = activeCurrency;

  static final actCurrency = _box.get(activeCurrency) == null
      ? 'USD'
      : _box.get(activeCurrency) as String;

  final activeCurr = actCurrency.obs;

  ThemeMode get theme => _loadTheme() == 0
      ? ThemeMode.system
      : _loadTheme() == 1
          ? ThemeMode.light
          : ThemeMode.dark;
  int _loadTheme() => _box.get(_themKey) ?? 0;

  void saveTheme(int isDarkMode) => _box.put(_themKey, isDarkMode);
  void changeTheme(ThemeData theme) => Get.changeTheme(theme);
  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

  void saveCurrency(String activeCur) {
    activeCurr.value = activeCur;
    Map rates = _box.get(rateKey);
    var currRate = rates[activeCur];

    _box.put(activeRate, currRate);
    _box.put(activeCurrency, activeCur);
  }
}
