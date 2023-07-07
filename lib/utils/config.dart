import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:google_fonts/google_fonts.dart';

const defaultPadding = 12.0;

final List appThemes = [
  {
    'title': systemTheme,
    'icon': IconlyLight.setting,
    'theme': ThemeMode.system,
  },
  {
    'title': lightTheme,
    'icon': Entypo.light_up,
    'theme': ThemeMode.light,
  },
  {
    'title': darkTheme,
    'icon': Icons.dark_mode_outlined,
    'theme': ThemeMode.dark,
  },
];

Map<String, ThemeData> themeDatas = {
  lightTheme: ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
    splashColor: darkAccent,
  ),
};
