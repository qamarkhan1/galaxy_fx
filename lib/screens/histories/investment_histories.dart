import 'package:flutter/material.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/history_wid.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';

import '../../backends/all_repos.dart';
import '../../controllers/investment_history_ctrl.dart';

class InvestmentHistories extends GetView {
  const InvestmentHistories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InvestmentHistoryCtrl investHistoryCtrl =
        Get.put(InvestmentHistoryCtrl());
    final AllRepos allRepos = AllRepos();
    return CustScaffold(
      title: 'Transactions Log',
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: investHistoryCtrl.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: investHistoryCtrl.isLoading.value,
                  data: snapshot.data == null ? [] : snapshot.data!,
                  lData: investHistoryCtrl.lData,
                  onEndOfPage: () => investHistoryCtrl.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!;
                    return HistoryTile(
                      amount: dt[index]['active'] == null
                          ? dt[index]['interest']
                          : dt[index]['amount'],
                      date: dt[index]['created_at'],
                      payMethod: dt[index]['active'] == null
                          ? 'Interest'
                          : 'Investment',
                      status: dt[index]['active'] ?? 1,
                      type: dt[index]['active'] == null ? deposit : withdrawal,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
