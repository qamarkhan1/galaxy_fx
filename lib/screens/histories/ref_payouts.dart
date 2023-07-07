import 'package:flutter/material.dart';
import 'package:forex_guru/controllers/ref_payouts_ctrl.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/history_wid.dart';
import 'package:get/get.dart';

import '../../backends/all_repos.dart';
import '../../widgets/lazy_load_wid.dart';

class RefPayouts extends GetView {
  const RefPayouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefPayoutsCtrl refPayoutsCtrl = Get.put(RefPayoutsCtrl());
    final AllRepos allRepos = AllRepos();
    return CustScaffold(
      title: 'Ref Bonus Payouts',
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: refPayoutsCtrl.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: refPayoutsCtrl.isLoading.value,
                  data: snapshot.data == null ? [] : snapshot.data!,
                  lData: refPayoutsCtrl.lData,
                  onEndOfPage: () => refPayoutsCtrl.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!;
                    String? type = dt[index]['type'];
                    return HistoryTile(
                      amount: dt[index]['amount'],
                      date: dt[index]['created_at'],
                      payMethod: type.capitalize(),
                      status: payStatus.indexOf(dt[index]['status']),
                      type: type == 'payout' ? withdrawal : deposit,
                      // isRef: true,
                    );
                  },
                ),
              ),
            );
          },
        ),

        //     Column(
        //   children: const [
        //     HistoryTile(
        //       amount: 30.2,
        //       date: '02 Nov 2022 - 11:23',
        //       payMethod: 'Payout',
        //       status: 2,
        //       type: deposit,
        //     ),
        //     HistoryTile(
        //       amount: 61.65,
        //       date: '01 Nov 2022 - 09:34',
        //       payMethod: 'Earning',
        //       status: 2,
        //       type: withdrawal,
        //     ),
        //   ],
        // )
      ),
    );
  }
}
