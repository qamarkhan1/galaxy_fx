import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/screens/signal_detail.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/route_manager.dart';

import '../controllers/signals_ctrl.dart';
import '../utils/colors.dart';
import '../widgets/lazy_load_wid.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({Key? key}) : super(key: key);

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
//   @override
  @override
  Widget build(BuildContext context) {
    final SignalsCtrl signalCtrl = Get.put(SignalsCtrl());
    final AllRepos allRepos = AllRepos();

    Size med = MediaQuery.of(context).size;

    return CustScaffold(
      title: 'Signals',
      leading: const SizedBox.shrink(),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(CupertinoIcons.refresh))
      ],
      body: SizedBox(
        height: med.height * 0.74,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).textTheme.bodyText1!.color,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyText1!.color,
              onTap: (int index) {
                // setState(() {});
              },
              tabs: const [
                Tab(
                  text: 'Free',
                ),
                Tab(
                  text: 'Paid',
                ),
              ],
              controller: signalCtrl.controller,
              indicatorSize: TabBarIndicatorSize.label,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: TabBarView(
                  controller: signalCtrl.controller,
                  children: [
                    // ListView.builder(
                    //     itemCount: 10,
                    //     itemBuilder: (context, int index) {
                    //       return const SignalWid(
                    //         from: 'GBP',
                    //         to: 'CAD',
                    //         date: 1638667880000,
                    //         active: 1,
                    //         status: 1,
                    //         option: 1,
                    //       );
                    //     }),

                    FutureBuilder<Map>(
                        future: allRepos.getAllSignals(),
                        builder: (context, snapshot) {
                          return allRepos.snapshotFuture(
                            snapshot,
                            Obx(
                              () => LazyLoadWid(
                                height: 0.6,
                                isLoading: signalCtrl.isLoading.value,
                                data: snapshot.data == null
                                    ? []
                                    : snapshot.data!['free'],
                                lData: signalCtrl.lData,
                                onEndOfPage: () => signalCtrl.loadMore(false),
                                itemBuilder: (context, index) {
                                  var dt = snapshot.data!['free'];
                                  Map data = dt[index];
                                  return SignalWid(
                                    market: dt[index]['market'],
                                    date: dt[index]['open_time'],
                                    active: dt[index]['status'],
                                    status: data['trade_result'],
                                    option: dt[index]['action'],
                                    data: data,
                                  );
                                },
                              ),
                            ),
                            hasBack: false,
                          );
                        }),
                    FutureBuilder<Map>(
                        future: allRepos.getAllSignals(),
                        builder: (context, snapshot) {
                          return allRepos.snapshotFuture(
                            snapshot,
                            Obx(
                              () => LazyLoadWid(
                                height: 0.6,
                                isLoading: signalCtrl.isLoading.value,
                                data: snapshot.data == null
                                    ? []
                                    : snapshot.data!['paid'],
                                lData: signalCtrl.lDataPaid,
                                onEndOfPage: () =>
                                    signalCtrl.loadMorePaid(false),
                                itemBuilder: (context, index) {
                                  var dt = snapshot.data!['paid'];

                                  Map data = dt[index];
                                  return SignalWid(
                                    market: dt[index]['market'],
                                    date: dt[index]['open_time'],
                                    active: dt[index]['status'],
                                    status: data['trade_result'],
                                    option: dt[index]['action'],
                                    data: data,
                                  );
                                },
                              ),
                            ),
                            hasBack: false,
                          );
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignalWid extends StatelessWidget {
  const SignalWid({
    Key? key,
    required this.market,
    required this.date,
    required this.active,
    required this.status,
    required this.option,
    required this.data,
  }) : super(key: key);

  final String market;
  final String date;
  final String active;
  final String? status;
  final String option;
  final Map? data;
  @override
  Widget build(BuildContext context) {
    // String _date = DateFormat("dd-MM-yyyy hh:mm a")
    //     .format(DateTime.fromMillisecondsSinceEpoch(date));

    return InkWell(
      onTap: () => Get.to(() => SignalDetailScreen(data: data!)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      active,
                      style: TextStyle(
                        fontSize: 12,
                        color: active == 'active' ? green : null,
                      ),
                    ),
                    Text(
                      (status ?? 'Pending'),
                      style: TextStyle(
                        fontSize: 16,
                        color: status == null || status == 'Pending'
                            ? amber
                            : status == 'Take Profit'
                                ? green
                                : red,
                      ),
                    ),
                  ],
                ),
                Text(
                  option.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: option == 'buy' ? green : red,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
