import 'package:flutter/material.dart';
import 'package:forex_guru/controllers/sub_hist_ctrl.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';

import '../../backends/all_repos.dart';
import '../../utils/strings.dart';
import '../../widgets/history_wid.dart';

class SubscriptionsHistory extends GetView {
  const SubscriptionsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubscriptionHistoryCtrl subHistoryCtrl =
        Get.put(SubscriptionHistoryCtrl());
    final AllRepos allRepos = AllRepos();

    return CustScaffold(
      title: 'Subscriptions Log',
      body: SingleChildScrollView(
        child: FutureBuilder<Map>(
          future: subHistoryCtrl.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: subHistoryCtrl.isLoading.value,
                  data: snapshot.data == null
                      ? []
                      : snapshot.data!['subscriptionHistory'],
                  lData: subHistoryCtrl.lData,
                  onEndOfPage: () => subHistoryCtrl.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!['subscriptionHistory'];
                    return HistoryTile(
                      amount: dt[index]['amount'],
                      date: dt[index]['created_at'],
                      payMethod: 'Subscription',
                      status: 1,
                      type: withdrawal,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),

      //  SingleChildScrollView(
      //     child: Column(
      //   children: const [
      //     HistoryTile(
      //       amount: 30.2,
      //       date: '02 Nov 2022 - 11:23',
      //       payMethod: 'Starter Plan',
      //       status: completed,
      //       type: deposit,
      //     ),
      //   ],
      // )),
    );
  }
}

// class HistoryTile extends GetView {
//   const HistoryTile({
//     Key? key,
//     required this.type,
//     required this.payMethod,
//     required this.date,
//     required this.amount,
//     required this.status,
//   }) : super(key: key);

//   final String type;
//   final String payMethod;
//   final String date;
//   final dynamic amount;
//   final String status;
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: type == deposit ? green : red,
//         child: Icon(
//           type == deposit ? Feather.arrow_up : Feather.arrow_down,
//           size: 20,
//           color: white,
//         ),
//       ),
//       title: Text(payMethod),
//       subtitle: Text(date),
//       trailing: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Text(
//               '\$ $amount',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               status,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: payStatusColor[payStatus.indexOf(status)],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
