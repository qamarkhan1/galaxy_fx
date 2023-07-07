import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/settings_ctrl.dart';
import 'package:forex_guru/screens/more/auth_screen.dart';
import 'package:forex_guru/screens/more/change_password.dart';
import 'package:forex_guru/screens/more/change_pin.dart';
import 'package:forex_guru/screens/more/notifications.dart';
import 'package:forex_guru/screens/more/payout.dart';
import 'package:forex_guru/screens/more/profile.dart';
import 'package:forex_guru/screens/more/support.dart';
import 'package:forex_guru/screens/refer.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_tile.dart';
import 'package:get/get.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountScreen extends GetView {
  const AccountScreen({Key? key}) : super(key: key);

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {

  // final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();
    final SettingsController settingsController = Get.put(SettingsController());

    var usersBx = Hive.box(users);
    var settingsBx = Hive.box(settings);

    List currencyList = settingsBx.get(currenciesKey);

    return CustScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'More',
                      // style: Theme.of(context).textTheme.headline4,

                      style: TextStyle(
                        fontSize: 24,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                      color: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account',
                        // style: Theme.of(context).textTheme.headline6,
                      ),
                      ValueListenableBuilder(
                          valueListenable: usersBx.listenable(),
                          builder: (context, Box bxDt, widget) {
                            return Card(
                              elevation: 0.2,
                              child: Column(
                                children: [
                                  CustTile(
                                    title: 'Your Profile',
                                    icon: Feather.user,
                                    onTap: () =>
                                        Get.to(() => const ProfileScreen()),
                                  ),
                                  CustTile(
                                    title: 'Notifications',
                                    icon: Feather.bell,
                                    onTap: () => Get.to(
                                        () => const NotificationScreen()),
                                  ),
                                  CustTile(
                                    title: 'Payout Details',
                                    icon: AntDesign.bank,
                                    onTap: () =>
                                        Get.to(() => const PayoutScreen()),
                                  ),
                                ],
                              ),
                            );
                          }),
                      const SizedBox(height: 10),
                      const Text('Settings'),
                      Obx(
                        () => Card(
                          elevation: 0.2,
                          child: Column(
                            children: [
                              CustTile(
                                title: 'Theme',
                                icon: Feather.moon,
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'Select Theme',
                                    content: SizedBox(
                                      height: 180,
                                      width: 250,
                                      child: Center(
                                        child: ListView(
                                          children: List.generate(
                                            appThemes.length,
                                            (index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  settingsController
                                                      .changeThemeMode(
                                                          appThemes[index]
                                                              ['theme']);
                                                  settingsController
                                                      .saveTheme(index);
                                                },
                                                child: ListTile(
                                                    leading: Icon(
                                                      appThemes[index]['icon'],
                                                    ),
                                                    title: Text(appThemes[index]
                                                        ['title']),
                                                    trailing: settingsController
                                                                .theme.index ==
                                                            index
                                                        ? Icon(
                                                            Octicons.check,
                                                            color: green,
                                                          )
                                                        : const SizedBox
                                                            .shrink()),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    // actions: [
                                    //   CupertinoButton(
                                    //     child: Text('Cancel'),
                                    //     onPressed: () => Get.back(),
                                    //   ),
                                    //   CupertinoButton(
                                    //     child: Text('Ok'),
                                    //     onPressed: () => Get.back(),
                                    //   ),
                                    // ]
                                    // onCancel: onCancel,
                                    // onConfirm: onConfirmm,
                                    // actions: iosActions,
                                  );
                                },
                                trailing: Text(
                                  appThemes[Get.find<SettingsController>()
                                      .theme
                                      .index]['title'],
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              CustTile(
                                title: 'Currency',
                                icon: CupertinoIcons.money_dollar_circle,
                                trailing:
                                    //  currency == null
                                    //     ? Text(currentCurrency, style: TextStyle())
                                    //     :

                                    Text(
                                  Get.find<SettingsController>()
                                      .activeCurr
                                      .value,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                onTap: () => allRepos.showPicker(
                                  context,
                                  children: currencyList,
                                  onSelectedItemChanged: (value) {
                                    String currency = currencyList[value!];
                                    settingsController.saveCurrency(currency);
                                  },
                                  onChanged: (String? val) {
                                    settingsController.saveCurrency(val!);

                                    Navigator.pop(context);
                                  },
                                  hasTrns: false,
                                ),
                              ),
                              CustTile(
                                title: 'Language',
                                icon: Icons.language_outlined,
                                trailing:
                                    //  currency == null
                                    //     ? Text(currentCurrency, style: TextStyle())
                                    //     :

                                    Text(
                                  english.capitalizeFirst!,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                onTap: () => allRepos.showPicker(
                                  context,
                                  children: languageList,
                                  hasTrns: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Security'),
                      Card(
                        elevation: 0.2,
                        child: Column(
                          children: [
                            CustTile(
                              title: 'Auths',
                              icon: Icons.fingerprint,
                              onTap: () => Get.to(() => const AuthScreen()),
                            ),
                            // CustTile(
                            //   title: 'Two-Factor Authentication',
                            //   icon: Feather.shield,
                            //   onTap: () => Get.to(() => const TwoFaScreen()),
                            // ),
                            CustTile(
                              title: 'Change Password',
                              icon: Feather.lock,
                              onTap: () => Get.to(() => const ChangePassword()),
                            ),
                            CustTile(
                              title: 'Change Pin',
                              icon: Icons.pin_outlined,
                              onTap: () => Get.to(() => const ChangePin()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('others'),
                      Card(
                        elevation: 0.2,
                        child: Column(
                          children: [
                            CustTile(
                              title: 'Affiliates & Referrals',
                              icon: Feather.users,
                              onTap: () => Get.to(() => const ReferScreen()),
                            ),
                            CustTile(
                              title: 'Talk to support',
                              icon: Feather.message_circle,
                              onTap: () => Get.to(() => const SupportScreen()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          try {
                            allRepos.signOut();
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                            allRepos.showSnacky('Sign Out Failed', false);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log Out',
                              style: TextStyle(color: primaryColor),
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Feather.log_out,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
