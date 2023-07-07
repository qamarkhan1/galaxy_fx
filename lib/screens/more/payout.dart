import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/screens/more/payouts/add_edit.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';
import 'package:forex_guru/utils/config.dart';

import '../../controllers/payout_ctrl.dart';
import '../../utils/strings.dart';

class PayoutScreen extends StatefulWidget {
  const PayoutScreen({Key? key}) : super(key: key);

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    final PayoutController payoutController = Get.put(PayoutController());
    int index = 0;
    return CustScaffold(
      title: '',
      leading: InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: () {
          if (index == 0) {
            Get.back();
          } else {
            payoutController.changeIndex(false, index);
          }
        },
        child: index == 0
            ? Icon(
                Feather.x,
                color: primaryColor,
              )
            : Icon(
                Icons.arrow_back,
                color: primaryColor,
              ),
      ),
      backgroundColor: transparent,
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: FutureBuilder<List>(
              future: allRepos.getAllPayoutMethods(),
              builder: (context, snapshot) {
                return allRepos.snapshotFuture(
                  snapshot,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beneficiaries',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot.data == null || snapshot.data!.isEmpty
                          ? emptyWidget()
                          : LazyLoadWid(
                              height: 0.6,
                              isLoading: payoutController.isLoading.value,
                              data: snapshot.data == null ? [] : snapshot.data!,
                              lData: payoutController.lData,
                              onEndOfPage: () =>
                                  payoutController.loadMore(false),
                              itemBuilder: (context, index) {
                                var dt = snapshot.data!;
                                Map data = dt[index];
                                return Card(
                                    child: ListTile(
                                  title: Text(data['payment_method']),
                                  subtitle: const Text('Payment Method'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.to(PayoutsAddEdit(data: data));
                                        },
                                        icon: const Icon(IconlyLight.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          try {
                                            await allRepos.deletePayoutMethod(
                                                data['id'].toString());
                                            setState(() {});
                                            allRepos.showFlush(success,
                                                success: true);
                                          } catch (e) {
                                            allRepos.showFlush(defaultError,
                                                success: false);
                                          }
                                        },
                                        icon: Icon(
                                          IconlyLight.delete,
                                          color: red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              },
                            ),
                    ],
                  ),
                  customEmpty: emptyWidget(),
                );
              }),
        ),
      ),
    );
  }

  Widget emptyWidget() {
    // final PayoutController payoutController = Get.put(PayoutController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beneficiaries',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No Beneficiary added yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Tap the button below to add beneficiary'),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Get.to(const PayoutsAddEdit());
                    },
                    splashColor: transparent,
                    highlightColor: transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Beneficiary',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Feather.plus,
                          size: 20,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
