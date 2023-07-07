import 'package:flutter/material.dart';
import 'package:forex_guru/controllers/ref_history_ctrl.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/history_wid.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';

import '../../backends/all_repos.dart';

class ReferralsHistory extends GetView {
  const ReferralsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefHistoryCtrl refHistoryCtrl = Get.put(RefHistoryCtrl());
    final AllRepos allRepos = AllRepos();

    return CustScaffold(
      title: 'Referrals Log',
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: refHistoryCtrl.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: refHistoryCtrl.isLoading.value,
                  data: snapshot.data == null ? [] : snapshot.data!,
                  lData: refHistoryCtrl.lData,
                  onEndOfPage: () => refHistoryCtrl.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!;
                    return HistoryTile(
                      amount: dt[index]['amount'] ?? 0,
                      date: dt[index]['created_at'],
                      payMethod: dt[index]['referred_email'],
                      status: dt[index]['active'],
                      type: withdrawal,
                      isRef: true,
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
