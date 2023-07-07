import 'package:flutter/material.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/utils/tawk/src/tawk_widget.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controllers/misc_ctrl.dart';

class SupportScreen extends GetView {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(settings);
    Map moreDts = box.get(more) ?? {};

    // ignore: unused_local_variable
    final MiscCtrl miscCtrl = Get.put(MiscCtrl());
    return CustScaffold(
      title: '',
      body: Tawk(
        directChatLink: moreDts['tawk_link'] ?? "",
        // onLoad: () {
        //   print('Hello Tawk!');
        // },
        // onLinkTap: (String url) {
        //   print(url);
        // },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
