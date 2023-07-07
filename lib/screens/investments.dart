import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/screens/histories/investment_histories.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_text_field.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:hive_flutter/adapters.dart';

import '../backends/all_repos.dart';
import '../controllers/investments_ctrl.dart';
import '../utils/strings.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({Key? key}) : super(key: key);

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

final AllRepos _allRepos = AllRepos();

class _InvestmentsScreenState extends State<InvestmentsScreen> {
//   @override

  static final settingsBx = Hive.box(settings);
  var currRate = settingsBx.get(activeRate) ?? defaultRate;
  String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;

  @override
  Widget build(BuildContext context) {
    final InvestmentsCtrl investCtrl = Get.put(InvestmentsCtrl());

    Size med = MediaQuery.of(context).size;

    return CustScaffold(
      onRefresh: () async {},
      // title: 'Investment Packages',
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<Map>(
                future: _allRepos.getUserData(),
                builder: (context, snapshot) {
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
                                        onTap: () => Get.back(),
                                        child: Icon(
                                          Feather.x,
                                          color: white,
                                        )),
                                    IconButton(
                                      onPressed: () => Get.to(
                                          () => const InvestmentHistories()),
                                      icon: Icon(
                                        Entypo.list,
                                        color: white,
                                      ),
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
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // snapshot.data == null
                                      //     ? CustProgIndicator()
                                      //     :
                                      Text(
                                        investCtrl.showBal.value
                                            ? (snapshot.data == null ||
                                                    snapshot.data!.isEmpty
                                                ? '$curr loading'
                                                : '$curr ${(snapshot.data!['userBalance']['balance'] * currRate).toStringAsFixed(2)}')
                                            : '*****',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                          fontFamily:
                                              GoogleFonts.libreBaskerville()
                                                  .fontFamily,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      investCtrl.showBal.value
                                          ? IconButton(
                                              onPressed: () =>
                                                  investCtrl.toggleBal(false),
                                              icon: Icon(
                                                Feather.eye_off,
                                                size: 20,
                                                color: white,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () =>
                                                  investCtrl.toggleBal(true),
                                              icon: Icon(
                                                Feather.eye,
                                                size: 20,
                                                color: white,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Net Profit',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                snapshot.data == null || snapshot.data!.isEmpty
                                    ? '$curr loading'
                                    : '$curr ${(snapshot.data!['userBalance']['net_profit'] * currRate).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: green,
                                  fontFamily:
                                      GoogleFonts.libreBaskerville().fontFamily,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ListTile(
                          leading: CircleAvatar(
                            radius: 12,
                            child: Icon(
                              Octicons.flame,
                              size: 14,
                            ),
                          ),
                          title: Text('Investment Plans'),
                          // trailing: Icon(Icons.chevron_right),
                        ),
                        // const SizedBox(height: 20),
                        FutureBuilder<Map>(
                          future: investCtrl.future,
                          builder: (context, snapshot) {
                            return _allRepos.snapshotFuture(
                              snapshot,
                              Obx(
                                () => LazyLoadWid(
                                  isLoading: investCtrl.isLoading.value,
                                  data: snapshot.data == null
                                      ? []
                                      : snapshot.data!['investmentPlans'],
                                  lData: investCtrl.lData,
                                  onEndOfPage: () => investCtrl.loadMore(false),
                                  padding: const EdgeInsets.only(bottom: 200),
                                  itemBuilder: (context, index) {
                                    var dt = snapshot.data!['investmentPlans'];
                                    return InvestmentCardsWid(
                                      duration: dt[index]['duration'],
                                      maxAmount: dt[index]['max_amount'],
                                      roi: dt[index]['roi'],
                                      minAmount: dt[index]['min_amount'],
                                      title: dt[index]['title'],
                                      index: index + 1,
                                      onTap: () => popAmount(dt[index]),
                                    );
                                    //  SizedBox(
                                    //   height: 200,
                                    //   child: ListView.builder(
                                    //       shrinkWrap: true,
                                    //       scrollDirection: Axis.horizontal,
                                    //       itemCount: 3,
                                    //       itemBuilder: (context, int index) {
                                    //         return const InvestmentCardsWid();
                                    //       }),
                                    // );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 400,
                  //   color: white,
                  //   child: Column(
                  //     children: [
                  //       const ListTile(
                  //         // leading: CircleAvatar(
                  //         //   radius: 12,
                  //         //   child: Icon(
                  //         //     Entypo.shopping_bag,
                  //         //     size: 14,
                  //         //   ),
                  //         // ),
                  //         title: Text('My Investments'),
                  //         trailing: Icon(Icons.chevron_right),
                  //       ),
                  //       ListTile(
                  //         leading: const CircleAvatar(
                  //           // radius: 12,
                  //           child: Icon(
                  //             Entypo.shopping_bag,
                  //             size: 20,
                  //           ),
                  //         ),
                  //         title: const Text('Package Name'),
                  //         subtitle: const Text('1 Month'),
                  //         trailing: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             const Expanded(
                  //               child: Text('\$ 34.66'),
                  //             ),
                  //             Expanded(
                  //               child: Text(
                  //                 ' 9.02 %',
                  //                 style: TextStyle(
                  //                   fontSize: 12,
                  //                   color: green,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController amountCtrl = TextEditingController();

  popAmount(data) {
    String newMin = (currRate * data['min_amount']).toStringAsFixed(2);
    String newMax = (currRate * data['max_amount']).toStringAsFixed(2);
    _allRepos.showModalBar(Container(
      height: 400,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          CustTextField(
            controller: amountCtrl,
            hintText: "$newMin - $newMax",
            lableText: 'Amount To Invest',
          ),
          const SizedBox(height: 10),
          CustButton(
            onTap: () => investFxn(data),
            title: "Invest",
          ),
        ],
      ),
    ));
  }

  investFxn(data) {
    {
      try {
        String amount = (double.parse(amountCtrl.text.trim()) / currRate)
            .toStringAsFixed(2);
        Map body = {
          'reference': data['reference'],
          'amount': amount,
        };
        _allRepos.makeInvest(body).then((value) {
          if (value) {
            setState(() {});
          }
        });
      } catch (e) {
        _allRepos.showFlush(e.toString(), backgroundColor: red);
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}

class InvestmentCardsWid extends StatelessWidget {
  const InvestmentCardsWid({
    Key? key,
    required this.title,
    required this.minAmount,
    required this.maxAmount,
    required this.roi,
    required this.duration,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final dynamic minAmount;
  final dynamic maxAmount;
  final dynamic roi;
  final int duration;
  final int index;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        shadowColor: grey,
        // elevation: 0.5,
        child: Container(
          height: 220,
          width: 250,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/invest/invest_$index.png',
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$roi %',
                        style: TextStyle(
                          color: green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Return on Investment',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                color: primaryColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$curr ${(minAmount * currRate).toStringAsFixed(2)} - ${(maxAmount * currRate).toStringAsFixed(2)} Max Investment - $duration Month',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              CustButton(
                onTap: onTap,
                title: 'Invest',
                isHollow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
