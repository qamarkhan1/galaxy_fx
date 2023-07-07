// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/start_page_ctrl.dart';
import 'package:forex_guru/screens/home.dart';
import 'package:forex_guru/utils/app_defaults.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_prog_ind.dart';
import 'package:forex_guru/widgets/cust_text_field.dart';
import 'package:forex_guru/widgets/text_link.dart';

import 'package:forex_guru/utils/config.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

class StartPageScreen extends GetView {
  StartPageScreen({Key? key}) : super(key: key);

  final StartPageCtrl startPageCtrl = Get.put(StartPageCtrl());

  final AllRepos _allRepos = AllRepos();
  // bool? checkedValue = false;

  static var settingsBx = Hive.box(settings);
  static final box = Hive.box(users);

  static final userSettings = box.get(userNotify);

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();
  final TextEditingController _refCodeCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  // final String _result = '';

  static var settingsBox = Hive.box(settings);
  Map moreDts = settingsBox.get(more) ?? {};

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: startPageCtrl.loading.value,
        progressIndicator: const CustProgIndicator(),
        child: Scaffold(
          backgroundColor: primaryColor,
          body:
              // GlassmorphicContainer(
              //   width: double.infinity,
              //   height: med.height,
              //   borderRadius: 0,
              //   blur: 100,
              //   alignment: Alignment.bottomCenter,
              //   border: 0,
              //   linearGradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       blue.withOpacity(1.0),
              //       primaryColor.withOpacity(1.0),
              //     ],
              //     stops: const [
              //       0.1,
              //       1,
              //     ],
              //   ),
              //   borderGradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       blue.withOpacity(0.5),
              //       primaryColor.withOpacity(0.5),
              //     ],
              //   ),
              //   child:
              Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox.shrink(),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 25,
                    color: white,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustButton(
                      onTap: () => popUnlock(true, context),
                      title: 'Sign Up',
                      color: black,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      textColor: white,
                    )),
                    Expanded(
                        child: CustButton(
                      onTap: () => popUnlock(false, context),
                      title: 'Sign In',
                      color: white,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      textColor: black,
                    )),
                  ],
                ),
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }

  popUnlock(bool signUp, context) {
    _allRepos.showModalBar(
      Material(
        child: StatefulBuilder(builder: (context, dialogState) {
          return Container(
            // height: 720,
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      signUp ? 'Get Started' : 'Welcome Back',
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 50),
                    signUp
                        ? Column(
                            children: [
                              CustTextField(
                                lableText: 'Full Name',
                                controller: _nameCtrl,
                                validator: _allRepos.validateName,
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox.shrink(),
                    CustTextField(
                      lableText: 'Email',
                      controller: _emailCtrl,
                      validator: _allRepos.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustTextField(
                      obscureText: startPageCtrl.obscure.value,
                      lableText: 'Password',
                      controller: _passwordCtrl,
                      validator: signUp ? _allRepos.validatePassword : null,
                      suffix: IconButton(
                        icon: Icon(startPageCtrl.obscure.value
                            ? Feather.eye
                            : Feather.eye_off),
                        onPressed: () {
                          if (startPageCtrl.obscure.value) {
                            startPageCtrl.obscureFxn(false);
                          } else {
                            startPageCtrl.obscureFxn(true);
                          }
                          dialogState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    signUp
                        ? Column(
                            children: [
                              CustTextField(
                                obscureText: startPageCtrl.obscure.value,
                                lableText: 'Confirm Password',
                                controller: _confirmPassCtrl,
                                validator: validateCPass,
                                suffix: IconButton(
                                  icon: Icon(startPageCtrl.obscure.value
                                      ? Feather.eye
                                      : Feather.eye_off),
                                  onPressed: () {
                                    if (startPageCtrl.obscure.value) {
                                      startPageCtrl.obscureFxn(false);
                                    } else {
                                      startPageCtrl.obscureFxn(true);
                                    }
                                    dialogState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustTextField(
                                lableText: 'Referral Code',
                                controller: _refCodeCtrl,
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : const SizedBox.shrink(),
                    signUp
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                child: CheckboxListTile(
                                  activeColor: primaryColor,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(100.0))), // Rounded Checkbox

                                  // Rounded Checkbox

                                  checkboxShape: const CircleBorder(),

                                  value: startPageCtrl.checked.value,

                                  onChanged: (newValue) {
                                    // setState(() {
                                    startPageCtrl.checkFxn(newValue!);
                                    dialogState(() {});
                                    // checkedValue = newValue;
                                    // });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                        // fontSize: 14,
                                        ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _allRepos
                                            .launchUrlFxn(moreDts['privacy']);
                                      },
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      // fontSize: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    text: " and ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _allRepos
                                            .launchUrlFxn(moreDts['terms']);
                                      },
                                    text: "User Agreement",
                                    style: TextStyle(
                                      // fontSize: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                ])),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 10),
                    CustButton(
                      onTap: () => signUp ? signUpFxn() : signInFxn(),
                      title: signUp ? 'Sign Up' : 'Sign In',
                      textColor: white,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: black,
                          endIndent: 20,
                        )),
                        Text('${signUp ? "Sign up" : 'Sign In'} with'),
                        Expanded(
                            child: Divider(
                          color: black,
                          indent: 20,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButton(
                          onTap: web3login(_allRepos.withFacebook),
                          logo: 'facebook',
                        ),
                        SocialButton(
                          onTap: web3login(_allRepos.withGoogle),
                          logo: 'google',
                        ),
                        SocialButton(
                          onTap: web3login(_allRepos.withTwitter),
                          logo: 'twitter',
                        ),
                        SocialButton(
                          onTap: web3login(_allRepos.withApple),
                          logo: 'apple',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signUp
                              ? "Already have an account?"
                              : 'Don\'t have an account?',
                        ),
                        const SizedBox(width: 10),
                        TextLinkWid(
                          onTap: () {
                            Get.back();
                            Future.delayed(const Duration(milliseconds: 500))
                                .then((value) {
                              if (signUp) {
                                popUnlock(false, context);
                              } else {
                                popUnlock(true, context);
                              }
                            });
                          },
                          title: signUp ? "Sign In" : 'Sign Up',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String? validateCPass(String? value) {
    return _allRepos.validateCPassword(value!, _passwordCtrl.text.trim());
  }

  signUpFxn() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (startPageCtrl.checked.value) {
          Map data = {
            'name': _nameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
            'password': _passwordCtrl.text.trim(),
            'password_confirmation': _confirmPassCtrl.text.trim(),
            'refBy': _refCodeCtrl.text.isEmpty ? '' : _refCodeCtrl.text.trim(),
          };
          Get.back();
          startPageCtrl.loadingFxn(true);

          await _allRepos.signUp(data);
        } else {
          _allRepos.showFlush('Accept Terms', success: false);
        }
      }
    } catch (e) {
      _allRepos.showFlush(defaultError, success: false);
    }
    startPageCtrl.loadingFxn(false);
  }

  // Web3AuthResponse web3AuthResponse;

  signInFxn() async {
    try {
      // if (_formKey.currentState!.validate()) {
      //   _formKey.currentState!.save();

      // ! Notification
      // Get if user has login notification true
      // if true : call sendNotification

      startPageCtrl.loadingFxn(true);
      Map body = {
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      };
      bool status = await _allRepos.signIn(body);
      if (status) {
        if (userSettings != null) {
          bool loginPush = userSettings['login_push'] == null ||
                  userSettings['login_push'] == '1'
              ? true
              : false;
          bool loginMail = userSettings['login_mail'] == null ||
                  userSettings['login_mail'] == '1'
              ? true
              : false;
          if (loginPush) {
            pushNotificationData[email] = _emailCtrl.text.trim();
            // pushNotificationData['isTopic'] = false;
            await _allRepos.sendPushNotification(pushNotificationData);
          }
          if (loginMail) {
            mailNotificationData[email] = _emailCtrl.text.trim();
            await _allRepos.sendEmailNotification(mailNotificationData);
          }
        }

        await _allRepos.getUserData();

        Get.offAll(() => const HomePage());
      }
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    startPageCtrl.loadingFxn(false);
  }

  VoidCallback web3login(Future<Web3AuthResponse> Function() method) {
    return () async {
      try {
        Get.back();
        startPageCtrl.loadingFxn(true);

        final Web3AuthResponse response = await method();

        String? name = response.userInfo!.name;
        String? email = response.userInfo!.email;
        String? typeOfLogin = response.userInfo!.typeOfLogin;
        String? idToken = response.userInfo!.idToken;
        String? privKey = response.privKey;

        Map data = {
          'name': name,
          'email': email,
          'password': privKey,
          'password_confirmation': privKey,
          'refBy': typeOfLogin,
          '${typeOfLogin}_token': idToken,
          '${typeOfLogin}_refresh_token': idToken,
        };

        Map resBody = await _allRepos.socialLogin(
          {'email': email},
        );

        if (resBody[status]) {
          bool status = await _allRepos.signIn(data);
          if (status) {
            await _allRepos.getUserData();
            Get.offAll(() => const HomePage());
          }
        } else if (!resBody[status] &&
            resBody['0'][message] == 'call_register') {
          await _allRepos.signUp(data);
        }
        startPageCtrl.loadingFxn(false);
      } on UserCancelledException {
        _allRepos.showFlush('User cancelled.');
        startPageCtrl.loadingFxn(false);
      } on UnKnownException {
        _allRepos.showFlush('Unknown exception occurred');
        startPageCtrl.loadingFxn(false);
      } catch (e) {
        log('e $e');
        _allRepos.showFlush(defaultError);
        startPageCtrl.loadingFxn(false);
      }
    };
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.onTap,
    required this.logo,
  }) : super(key: key);

  final Function() onTap;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        'assets/svgs/$logo.svg',
        height: 35,
      ),
    );
  }
}
