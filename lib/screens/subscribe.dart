import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/subscription_ctrl.dart';
import 'package:forex_guru/screens/histories/subscription_histories.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';

import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:forex_guru/utils/config.dart';

import '../widgets/lazy_load_wid.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    // Size med = MediaQuery.of(context).size;
    final SubscriptionCtrl subsCtrl = Get.put(SubscriptionCtrl());
    final AllRepos allRepos = AllRepos();

    return CustScaffold(
      // title: 'Subscriptions',
      body: FutureBuilder<Map>(
        future: allRepos.getAllSubPlans(),
        builder: (context, snapshot) {
          return allRepos.snapshotFuture(
            snapshot,
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 330,
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
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () => Get.back(),
                                  child: Icon(
                                    Feather.x,
                                    color: white,
                                  )),
                              IconButton(
                                onPressed: () =>
                                    Get.to(() => const SubscriptionsHistory()),
                                icon: Icon(
                                  Entypo.list,
                                  color: white,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'My Active Subscription',
                              style: TextStyle(
                                color: white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 140,
                            width: double.infinity,
                            child: Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Image.asset(
                                            'assets/images/subscription_active.png'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            defaultPadding),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // snapshot.data != null ||
                                              //         snapshot.data!.isNotEmpty
                                              //     ? '${snapshot.data!['activeSub']['title']}'
                                              //     : 'loading',
                                              snapshot.data == null ||
                                                      snapshot.data!.isEmpty
                                                  ? 'loading'
                                                  : snapshot.data!['activeSub']
                                                      ['title'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Daily Forex Signals',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color!
                                                    .withOpacity(0.5),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                CurrencyTextSpan(
                                                  amount: snapshot.data ==
                                                              null ||
                                                          snapshot.data!.isEmpty
                                                      ? '0'
                                                      : snapshot
                                                          .data!['activeSub']
                                                              ['amount']
                                                          .toStringAsFixed(1),
                                                  // snapshot.data != null ||
                                                  //         snapshot.data!
                                                  //             .isNotEmpty
                                                  //     ? '${snapshot.data!['activeSub']['amount'].toStringAsFixed(1)}'
                                                  //     : '0',
                                                  duration: snapshot.data ==
                                                              null ||
                                                          snapshot.data!.isEmpty
                                                      ? ''
                                                      : snapshot
                                                          .data!['activeSub']
                                                              ['duration']
                                                          .toString(),

                                                  // snapshot.data != null ||
                                                  //         snapshot.data!
                                                  //             .isNotEmpty
                                                  //     ? snapshot.data![
                                                  //             'activeSub']
                                                  //             ['duration']
                                                  //         .toString()
                                                  //     : '',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalDivider(
                                    endIndent: 10,
                                    indent: 10,
                                    color: accent,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SleekCircularSlider(
                                        min: 0,
                                        max: snapshot.data == null ||
                                                snapshot.data!.isEmpty
                                            ? 0.0
                                            : (snapshot.data!['activeSub']
                                                        ['duration'] *
                                                    30)
                                                .toDouble(),
                                        initialValue: snapshot.data == null ||
                                                snapshot.data!.isEmpty
                                            ? 0.0
                                            : snapshot.data!['subscription']
                                                .toDouble(),
                                        appearance: CircularSliderAppearance(
                                          customWidths: CustomSliderWidths(
                                            progressBarWidth: 2,
                                            trackWidth: 1,
                                          ),
                                          size: 40,
                                          animDurationMultiplier: 2.0,
                                          customColors: CustomSliderColors(
                                              trackColor: accent,
                                              progressBarColor: primaryColor,
                                              hideShadow: true),
                                          infoProperties: InfoProperties(
                                            mainLabelStyle: TextStyle(
                                              color: primaryColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w100,
                                            ),
                                            modifier: (double value) {
                                              final daysLeft = snapshot.data ==
                                                          null ||
                                                      snapshot.data!.isEmpty
                                                  ? 0
                                                  : snapshot
                                                      .data!['subscription'];
                                              (value).toInt();
                                              return '$daysLeft';
                                            },
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Days Left',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Obx(
                          () => LazyLoadWid(
                            isLoading: subsCtrl.isLoading.value,
                            data: snapshot.data == null
                                ? []
                                : snapshot.data!['subscriptionPlans'],
                            lData: subsCtrl.lData,
                            onEndOfPage: () => subsCtrl.loadMore(false),
                            padding: const EdgeInsets.only(bottom: 100),
                            itemBuilder: (context, index) {
                              var dt = snapshot.data!['subscriptionPlans'];

                              int ind = index + 1;

                              return SizedBox(
                                height: snapshot.data!['subscriptionPlans']
                                            [index]['recommended'] ==
                                        1
                                    ? 200
                                    : 160,
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () =>
                                      popConfirmation(dt[index], allRepos),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        snapshot.data!['subscriptionPlans']
                                                    [index]['recommended'] ==
                                                1
                                            ? Container(
                                                height: 40,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Entypo.star,
                                                      color: white,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      'Best Offer',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dt[index]['title'],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CurrencyTextSpan(
                                                    amount: dt[index]['amount']
                                                        .toStringAsFixed(1),
                                                    duration: dt[index]
                                                            ['duration']
                                                        .toString(),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      dt[index]['description'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        // color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Image.asset(
                                                    'assets/images/subscription_$ind.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            height: 150,
          );
        },
      ),
    );
  }

  popConfirmation(data, AllRepos allRepos) {
    return allRepos.showPopUp(
      const Text('Are you sure you want to Purchase this plan?'),
      [
        CupertinoButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'plan_reference': data['reference'],
              };
              await allRepos.subscribe(body).then((value) {
                setState(() {});
              });
            } catch (e) {
              allRepos.showFlush('e.toString()', backgroundColor: red);
            }
          },
        ),
        CupertinoButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
      [
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'plan_reference': data['reference'],
              };
              await allRepos.subscribe(body);
            } catch (e) {
              allRepos.showFlush('e.toString()', backgroundColor: red);
            }
          },
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

class CurrencyTextSpan extends StatelessWidget {
  const CurrencyTextSpan({
    Key? key,
    required this.amount,
    this.duration = '',
  }) : super(key: key);

  final String amount;
  final String? duration;
  @override
  Widget build(BuildContext context) {
    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;

    String newAm = (double.parse(amount) * currRate).toStringAsFixed(2);
    return Text.rich(
      TextSpan(
        // text: defaultCurrencySymbol,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Text(
              curr,
              style: TextStyle(
                fontSize: 14,
                height: 1.0,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.5),
              ),
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.bottom,
            child: Text(
              newAm,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontFamily: GoogleFonts.libreBaskerville().fontFamily,
              ),
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              '- $duration month(s)',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
