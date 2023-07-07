import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/misc_ctrl.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AccountsScreen extends GetView {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(settings);
    Map moreDts = box.get(more) ?? {};

    // ignore: unused_local_variable
    final MiscCtrl miscCtrl = Get.put(MiscCtrl());

    return CustScaffold(
      title: 'More',
      leading: const SizedBox.shrink(),
      body: Column(
        children: [
          MoreListTile(
            onTap: () {
              final box = context.findRenderObject() as RenderBox?;

              Share.share(
                moreDts['shareMessage'],
                subject: moreDts['shareSubject'],
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
            },
            title: 'Share',
          ),
          MoreListTile(
            title: 'Risk Disclaimer',
            link: moreDts['disclaimer'],
          ),
          MoreListTile(
            title: 'Rate this app',
            link: Platform.isIOS ? moreDts['ios_app'] : moreDts['android_app'],
          ),
          MoreListTile(
            title: 'About',
            link: moreDts['about'],
          ),
          MoreListTile(
            title: 'Support',
            link: moreDts['support'],
          ),
          MoreListTile(
            title: 'Privacy',
            link: moreDts['privacy'],
          ),
          MoreListTile(
            title: 'Terms',
            link: moreDts['terms'],
          ),
        ],
      ),
    );
  }
}

class MoreListTile extends StatelessWidget {
  const MoreListTile({
    Key? key,
    required this.title,
    this.onTap,
    this.link,
  }) : super(key: key);

  final Function()? onTap;
  final String title;
  final String? link;
  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    return ListTile(
      title: Text(title),
      onTap: link == null
          ? onTap
          : () {
              allRepos.launchUrlFxn(link!);
            },
    );
  }
}
