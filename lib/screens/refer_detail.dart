import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/screens/histories/ref_payouts.dart';
import 'package:forex_guru/screens/histories/referrals_history.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReferDetailsScreen extends StatelessWidget {
  const ReferDetailsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map? data;
  @override
  Widget build(BuildContext context) {
    // Map refDetails = usersBx.get('refDetails') ?? {};
    Map refDetails = data ?? {};

    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;
    return CustScaffold(
      title: 'Referral Details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Unpaid Rewards'),
                    Text(
                      '$curr ${refDetails.isNotEmpty ? (refDetails['unpaid_rewards'] * currRate).toStringAsFixed(2) : 'loading'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.to(() => const RefPayouts()),
                  icon: const Icon(
                    Entypo.list,
                  ),
                )
              ],
            ),
          ),
          RefListWid(
            title: 'Total Rewards Earned',
            trailing:
                '$curr ${refDetails.isNotEmpty ? (refDetails['total_rewards'] * currRate).toStringAsFixed(2) : 'loading'}',
          ),
          RefListWid(
            title: 'SignUps',
            trailing:
                '${refDetails.isNotEmpty ? refDetails['total_sign_ups'] : 'loading'}',
          ),
          RefListWid(
            title: 'Active Sign Ups',
            trailing:
                '${refDetails.isNotEmpty ? refDetails['active_sign_ups'] : 'loading'}',
          ),
          RefListWid(
            title: 'Earnings Per Referral',
            trailing: '$curr ${(5.0 * currRate).toStringAsFixed(2)}',
          ),
          RefListWid(
            title: 'Next Payout Date',
            trailing:
                '${refDetails.isNotEmpty ? refDetails['next_payout'] : 'loading'}',
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: GestureDetector(
              onTap: () => Get.to(() => const ReferralsHistory()),
              child: const Text('Referral History'),
            ),
          ))
        ],
      ),
    );
  }
}

class RefListWid extends StatelessWidget {
  const RefListWid({
    Key? key,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: Text(trailing,
              style: const TextStyle(
                fontSize: 18,
              )),
        ),
        Divider(
          color: accent,
        ),
      ],
    );
  }
}
