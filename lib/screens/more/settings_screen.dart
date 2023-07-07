import 'package:flutter/material.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SettingsScreen extends GetView {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustScaffold(
      title: '',
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: const [],
        ),
      )),
    );
  }
}
