import 'package:flutter/material.dart';
import 'package:forex_guru/controllers/transactions_ctrl.dart';

import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';

import '../../backends/all_repos.dart';
import '../../utils/strings.dart';
import '../../widgets/history_wid.dart';
import '../../widgets/lazy_load_wid.dart';

class TransactionsHistory extends GetView {
  const TransactionsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TransactionsCtrl trxnHistoryCtrl = Get.put(TransactionsCtrl());
    final AllRepos allRepos = AllRepos();

    return CustScaffold(
      title: 'Transactions Log',
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: trxnHistoryCtrl.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: trxnHistoryCtrl.isLoading.value,
                  data: snapshot.data == null ? [] : snapshot.data!,
                  lData: trxnHistoryCtrl.lData,
                  onEndOfPage: () => trxnHistoryCtrl.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!;
                    String? paymentMethod = dt[index]['payment_method'];
                    String? trxnType = dt[index]['trnx_type'];
                    return HistoryTile(
                      amount: dt[index]['amount'],
                      date: dt[index]['created_at'],
                      payMethod: paymentMethod!,
                      status: payStatus.indexOf(dt[index]['status']),
                      type: trxnType!,
                      // isRef: true,
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
