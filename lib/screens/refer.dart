import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/screens/refer_detail.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ReferScreen extends GetView {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;
    return CustScaffold(
      title: '',
      // backgroundColor: accent,
      body: FutureBuilder<Map>(
          future: allRepos.getUserRefDetails(),
          builder: (context, snapshot) {
            return Container(
              // color: accent,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    child: Image.asset('assets/images/gift_1.png'),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Get free $curr  ${(5.0 * currRate).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // color: white,
                    ),
                  ),
                  const Text(
                    'We have exciting cash rewards for you and your friends, if they sign up with your referral code and either enrol in a course, subscribe to our signals or investment with us. Share your code now.',
                    style: TextStyle(
                        // color: white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Referral Code'.toUpperCase(),
                        // style: TextStyle(color: white),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: Card(
                              child: Container(
                                height: 50,
                                // width: 200,
                                padding: const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  // color: white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data == null ||
                                              snapshot.data!.isEmpty
                                          ? 'loading'
                                          : '${snapshot.data!['refcode'].toUpperCase()}',
                                      // refCode.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Icon(IconlyLight.document),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                              child: CustButton(
                            onTap: () {},
                            title: 'Share',
                            textColor: white,
                            // color: white,
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReferDetailsScreen(data: snapshot.data!),
                      ),
                    ),
                    child: Text(
                      'Show Referral Details'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        // color: white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          }),
    );
  }
}
