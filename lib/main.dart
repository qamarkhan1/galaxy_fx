import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/settings_ctrl.dart';
import 'package:forex_guru/screens/home.dart';
import 'package:forex_guru/screens/intro.dart';
import 'package:forex_guru/screens/lock_screen.dart';
import 'package:forex_guru/screens/start_page.dart';
import 'package:forex_guru/utils/app_defaults.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'firebase_options.dart';
import 'utils/routes.dart';

AllRepos _allRepos = AllRepos(); //pp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(users);
  await Hive.openBox(settings);

  await dotenv.load(fileName: ".env");

  _allRepos.currencyRatesGet();

  _allRepos.getMore();
  Stripe.publishableKey =
      "pk_test_51Hzs81HltcMZWTRDQfS919PWY77OJUxyiXURFHoAj8KhBCgGM3WPuSajKsTR8mj3nQUUYSKOPOEFm4qSvVaC8hAm00k904s1Qt";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  FluroRouter.setupRouter();

  cronJob();

  runApp(const MyApp());
}

cronJob() async {
  _allRepos.cronJob(checkBlockedFxn, 1);

  // Check Session
}

checkBlockedFxn() async {
  var userBx = Hive.box(users);

  if (userBx.isNotEmpty) {
    // Check Blocked Status
    Map user = await _allRepos.getUserData();
    if (user['user']['blocked'] == 1) {
      Get.offAll(StartPageScreen());
    }
  }
}

class MyApp extends GetView {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: Colors.red,
        splashColor: accent,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
        splashColor: darkAccent,
      ),
      themeMode: settingsController.theme,
      initialRoute: '/',
      onGenerateRoute: FluroRouter.router.generator,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => getScreen(),
      ),
      home: getScreen(),
    );
  }

  Widget getScreen() {
    var settingsBx = Hive.box(settings);
    var userBx = Hive.box(users);
    // userBx.clear();
    bool activePinCodeBx = settingsBx.get(activePinCode) ?? false;

    bool intro = settingsBx.get('intro') ?? false;
    String? accessToken = userBx.isEmpty ? '' : userBx.get('accessToken');

    if (intro) {
      if (accessToken!.isEmpty) {
        return StartPageScreen();
      } else {
        if (activePinCodeBx) {
          return const LockScreen();
        } else {
          return const HomePage();
        }
      }
    } else {
      return const IntroScreen();
    }
  }
}
