import 'package:flutter/material.dart';

import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key? key,
    required this.type,
    required this.payMethod,
    required this.date,
    required this.amount,
    required this.status,
    this.isRef = false,
  }) : super(key: key);

  final String type;
  final String payMethod;
  final String date;
  final dynamic amount;
  final int status;
  final bool? isRef;
  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    String newDate = allRepos.getNewDate(date);

    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isRef! ? white : (type == deposit ? green : red),
        child: Icon(
          isRef!
              ? Feather.user
              : (type == deposit ? Feather.arrow_down : Feather.arrow_up),
          size: 20,
          color: isRef! ? primaryColor : white,
        ),
      ),
      title: Text(payMethod),
      subtitle: Text(newDate),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              '$curr ${(amount * currRate).toStringAsFixed(2) ?? '0'}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isRef! ? (status == 1 ? active : inactive) : payStatus[status],
              style: TextStyle(
                fontSize: 12,
                color: isRef! ? payStatusColor[status] : payStatusColor[status],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
