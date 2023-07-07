import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/screens/account.dart';
import 'package:forex_guru/screens/front/deposit.dart';
import 'package:forex_guru/screens/histories/notifications_history.dart';
import 'package:forex_guru/screens/histories/transactions_histories.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/avatar_wid.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_text_field.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/front_screen_ctrl.dart';
import '../iframes/iframes.dart';
import 'package:forex_guru/utils/config.dart';

import '../utils/strings.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

AllRepos _allRepos = AllRepos();

class _FrontScreenState extends State<FrontScreen> {
  static TextEditingController amountCtrl = TextEditingController();

  WebViewController? _controller;
  WebViewController? _chartController;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(transparent)
      ..loadRequest(Uri.dataFromString(screenerWid(), mimeType: 'text/html'));

    final WebViewController chartController =
        WebViewController.fromPlatformCreationParams(params);

    // for (var i = 0; i < currencyPairs.length; i++) {
    chartController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(transparent)
      ..loadRequest(Uri.dataFromString(miniChartWidget(currencyPairs[0]),
          mimeType: 'text/html'));
    // }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
    _chartController = chartController;
  }

  dynamic currencyRate = 1.0;

  @override
  Widget build(BuildContext context) {
    final FrontScreenCtrl frontScreenCtrl = Get.put(FrontScreenCtrl());

    final box = Hive.box(users);
    final settingsBx = Hive.box(settings);

    Map userProfile = box.get('userProfile') ?? {};

    String name = userProfile['name'] ?? "";
    Size med = MediaQuery.of(context).size;
    return CustScaffold(
      onRefresh: () async {
        frontScreenCtrl.getWebView();
        frontScreenCtrl.future;
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          setState(() {});
        });
      },
      // title: '',
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child:
            // FutureBuilder<Map>(
            //     future: frontScreenCtrl.future,
            //     builder: (context, snapshot) {
            // String balance = userBalance['balance'] == null
            //     ? 'loading'
            //     : userBalance['balance'].toStringAsFixed(2);

            // return
            //
            Column(
          children: [
            ValueListenableBuilder(
                valueListenable: settingsBx.listenable(),
                builder: (context, Box bxDt, widget) {
                  String curr = bxDt.get(activeCurrency) ?? defaultCurrency;
                  var currRate = bxDt.get(activeRate) ?? defaultRate;
                  currencyRate = currRate;
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 250,

                        // color: blue,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: 200,
                          borderRadius: 0,
                          blur: 20,
                          alignment: Alignment.bottomCenter,
                          border: 0,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(1.0),
                              blue.withOpacity(1.0),
                            ],
                            stops: const [
                              0.1,
                              1,
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.5),
                              blue.withOpacity(0.5),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          Get.to(() => const AccountScreen()),
                                      child: AvatarWidget(name: name),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => Get.to(() =>
                                              const NotificationsHistory()),
                                          icon: Icon(
                                            Feather.bell,
                                            color: white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => Get.to(() =>
                                              const TransactionsHistory()),
                                          icon: Icon(
                                            Entypo.list,
                                            color: white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  'App Balance',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.nunito().fontFamily,
                                  ),
                                ),
                                FutureBuilder<Map>(
                                    future: _allRepos.getUserData(),
                                    builder: (context, snapshot) {
                                      return Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              frontScreenCtrl.showBal.value
                                                  ? (snapshot.data == null ||
                                                          snapshot.data!.isEmpty
                                                      ? '$curr loading'
                                                      : '$curr ${(snapshot.data!['userBalance']['balance'] * currRate).toStringAsFixed(2)}')
                                                  : "******",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: white,
                                                fontFamily: GoogleFonts
                                                        .libreBaskerville()
                                                    .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            frontScreenCtrl.showBal.value
                                                ? IconButton(
                                                    onPressed: () =>
                                                        frontScreenCtrl
                                                            .toggleBal(false),
                                                    icon: Icon(
                                                      Feather.eye_off,
                                                      size: 20,
                                                      color: white,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () =>
                                                        frontScreenCtrl
                                                            .toggleBal(true),
                                                    icon: Icon(
                                                      Feather.eye,
                                                      size: 20,
                                                      color: white,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 70,
                        width: med.width,
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: CustButton(
                                  onTap: () => Get.to(const DepositScreen()),
                                  title: 'Deposit',
                                  color: transparent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustButton(
                                  onTap: () => popModal(false, _allRepos),
                                  title: 'Withdraw',
                                  color: transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // color: green,
                      ),
                    ],
                  );
                }),
            SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //     height: 150,
                    //     width: double.infinity,
                    //     child: Card(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(defaultPadding),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   'App Balance',
                    //                   style: TextStyle(
                    //                     color: Theme.of(context)
                    //                         .textTheme
                    //                         .bodyText1!
                    //                         .color!
                    //                         .withOpacity(0.7),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Text(
                    //                       '\$80,000.56',
                    //                       style: TextStyle(
                    //                         fontSize: 25,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Theme.of(context)
                    //                             .textTheme
                    //                             .bodyText1!
                    //                             .color!,
                    //                       ),
                    //                     ),
                    //                     const SizedBox(width: 30),
                    //                     const Icon(
                    //                       Feather.eye,
                    //                       size: 20,
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //             const Icon(
                    //               IconlyLight.arrowRightCircle,
                    //               size: 30,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     )),

                    // const Text(
                    //   'Charts',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // SizedBox(
                    //     height: med.height,
                    //     // width: 523,
                    //     child: WebView(
                    //       initialUrl: Uri.dataFromString(screenerFrame,
                    //               mimeType: 'text/html')
                    //           .toString(),
                    //       javascriptMode: JavascriptMode.unrestricted,
                    //     )),
                    // SizedBox(
                    //   // height: 200,
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: chartWidget(med.height),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),

                    // const Text(
                    //   'Screener ',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    SingleChildScrollView(
                      // padding: const EdgeInsets.only(bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        height: med.height,
                        // width: 523,
                        child: WebViewWidget(controller: _controller!),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
          // );
          // }
        ),
      ),
    );
  }

  List<Widget> chartWidget(double height) {
    return List.generate(currencyPairs.length, (i) {
      return Container(
        color: transparent,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        height: 200,
        width: 200,
        // width: 523,
        child: WebViewWidget(
          controller: _chartController!,
        ),
      );
    });
  }

  String miniChartWidget(String pair) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    String themeMode = isDarkMode ? 'dark' : 'light';
    return '<!-- TradingView Widget BEGIN --><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body style=\'"margin: 0; padding: 0;\'><div class="tradingview-widget-container">  <div class="tradingview-widget-container__widget"></div> </body></html> <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js" async>  {  "symbol": "FX:$pair",  "width": "200",  "height": "200",  "locale": "en",  "dateRange": "12M",  "colorTheme": "$themeMode",  "trendLineColor": "rgba(41, 98, 255, 1)",  "underLineColor": "rgba(41, 98, 255, 0.3)",  "underLineBottomColor": "rgba(41, 98, 255, 0)",  "isTransparent": true,  "autosize": false,  "largeChartUrl": "",  "noTimeScale": false}  </script></div><!-- TradingView Widget END -->';
  }

  String screenerWid() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    String themeMode = isDarkMode ? 'dark' : 'light';
    return '<!-- TradingView Widget BEGIN --> <html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body style=\'"margin: 0; padding: 0;\'><div class="tradingview-widget-container"> <div class="tradingview-widget-container__widget"></div> <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-screener.js" async> { "width": 500, "height": 1000, "defaultColumn": "overview", "defaultScreen": "general", "market": "forex", "showToolbar": true, "colorTheme": "$themeMode", "locale": "en", "isTransparent": true}  </script></div>  </body></html> <!-- TradingView Widget END -->';
  }

  String payMethod = paypal;

  popModal(bool isDeposit, AllRepos allRepos) {
    return allRepos.showModalBar(
      Container(
        height: 500,
        padding: const EdgeInsets.all(defaultPadding),
        child: StatefulBuilder(builder: (context, modalState) {
          return Column(
            children: [
              CustTextField(
                hintText: '1000',
                lableText: 'Amount',
                controller: amountCtrl,
              ),
              ListTile(
                title: const Text('Payment Method'),
                trailing: GestureDetector(
                  onTap: () => allRepos.showPicker(
                    context,
                    children: withdrawalMethods,
                    hasTrns: false,
                    onChanged: (String? val) {
                      payMethod = val!;
                      setState(() {});
                      modalState(() {});
                    },
                    onSelectedItemChanged: (int? index) {
                      payMethod = withdrawalMethods[index!];
                      setState(() {});
                      modalState(() {});
                    },
                  ),
                  child: Text(payMethod.capitalize!),
                ),
              ),
              withdrawalButton()
            ],
          );
        }),
      ),
    );
  }

  withdrawalButton() {
    return Column(
      children: [
        const SizedBox(height: 15),
        CustButton(
          onTap: () => withdrawalFxn(),
          title: 'Withdraw',
        ),
      ],
    );
  }

  void withdrawalFxn() async {
    try {
      authWid(() async {
        Get.back();
        Get.back();

        String amount = (double.parse(amountCtrl.text.trim()) / currencyRate)
            .toStringAsFixed(2);

        Map body = {
          'amount': amount,
          'payment_method': payMethod,
          'transaction_id': "",
          'trnx_type': 'withdraw',
        };
        await _allRepos.withdrawFxn(body);
        setState(() {});
      });
    } catch (e) {
      _allRepos.showFlush(defaultError, success: false);
    }
  }

  authWid(Function() onUnlocked) {
    final settingsBx = Hive.box(settings);
    var lockPinBx = settingsBx.get(lockPin);
    String? currentPin = lockPinBx;
    var authBx = settingsBx.get(authConfig);

    var biometricsAuth = authBx['biometrics'] ?? false;
    _allRepos.showModalBar(ScreenLock(
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
          biometricsAuth ? () async => await _allRepos.authenticate() : null,
      onOpened:
          biometricsAuth ? () async => await _allRepos.authenticate() : null,
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
