import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignalDetailScreen extends GetView {
  const SignalDetailScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    String status = data['status'];
    return CustScaffold(
      title: data['market'],
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              KListTile(
                title: 'Action',
                subtitle: data['action'].toUpperCase(),
                color: data['action'] == 'buy' ? green : red,
              ),
              KListTile(
                title: 'Status',
                subtitle: status.capitalize(),
              ),
              KListTile(
                title: 'Opening time',
                subtitle: allRepos.getNewDate(data['open_time']),
              ),
              Divider(
                color: accent,
              ),
              KListTile(
                title: 'Open Price',
                subtitle: data['open_price'].toStringAsFixed(4),
                color: green,
              ),
              KListTile(
                title: 'Take Profit 1',
                subtitle: data['take_profit_1'].toStringAsFixed(4),
                color: green,
              ),
              KListTile(
                title: 'Take Profit 2',
                subtitle: data['take_profit_2'].toStringAsFixed(4),
                color: green,
              ),
              KListTile(
                title: 'Take Profit 3',
                subtitle: data['take_profit_3'].toStringAsFixed(4),
                color: green,
              ),
              Divider(
                color: accent,
              ),
              KListTile(
                title: 'Stop Loss',
                subtitle: data['stop_loss'].toStringAsFixed(4),
                color: red,
              ),
              KListTile(
                title: 'Trade Result',
                subtitle: data['trade_result'] ?? 'Pending',
                color: data['trade_result'] == null ||
                        data['trade_result'] == 'Pending'
                    ? amber
                    : data['trade_result'] == 'Take Profit'
                        ? green
                        : red,
              ),
              KListTile(
                title: 'Profit/Loss',
                subtitle: data['trade_result'] == null ||
                        data['trade_result'] == 'Pending'
                    ? "Pending"
                    : data['trade_result'] == 'Take Profit'
                        ? "+${data['profit']} pips"
                        : "-${data['profit']} pips",
                color: data['trade_result'] == null ||
                        data['trade_result'] == 'Pending'
                    ? amber
                    : data['trade_result'] == 'Take Profit'
                        ? green
                        : red,
              ),
              KListTile(
                title: 'Last Update',
                subtitle: allRepos.getNewDate(data['updated_at']),
              ),
              const SizedBox(height: 10),
              data['trade_result'] == null || data['trade_result'] == 'Pending'
                  ? const SizedBox.shrink()
                  : Container(
                      color:
                          data['trade_result'] == 'Take Profit' ? green : red,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        data['trade_result'] == 'Take Profit'
                            ? "Successful Trade"
                            : 'Unsuccessfull Trade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class KListTile extends StatelessWidget {
  const KListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.color,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        subtitle,
        style: TextStyle(color: color),
      ),
    );
  }
}
