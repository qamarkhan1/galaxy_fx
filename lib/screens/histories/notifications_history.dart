import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/notification_ctrl.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/lazy_load_wid.dart';
import 'package:get/get.dart';

class NotificationsHistory extends GetView {
  const NotificationsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());
    final AllRepos allRepos = AllRepos();

    return CustScaffold(
      title: 'Notifications',
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: notificationController.future,
          builder: (context, snapshot) {
            return allRepos.snapshotFuture(
              snapshot,
              Obx(
                () => LazyLoadWid(
                  isLoading: notificationController.isLoading.value,
                  data: snapshot.data == null ? [] : snapshot.data!,
                  lData: notificationController.lData,
                  onEndOfPage: () => notificationController.loadMore(false),
                  itemBuilder: (context, index) {
                    var dt = snapshot.data!;
                    Map data = dt[index];

                    String date = data['created_at'];
                    String newDate = allRepos.getNewDate(date);

                    String? topic = data['topic'] ?? "";
                    String title = data['title'];
                    String body = data['body'];

                    return ListTile(
                      onTap: () {
                        allRepos.showPopUp(
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                const SizedBox(height: 20),
                                Text(body),
                              ],
                            ),
                            [
                              CupertinoButton(
                                child: const Text('Ok'),
                                onPressed: () => Get.back(),
                              )
                            ],
                            [
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () => Get.back(),
                              )
                            ]);
                      },
                      leading: CircleAvatar(
                        child: Icon(
                          data['email'] == 'all'
                              ? Entypo.megaphone
                              : Entypo.bell,
                          size: 20,
                        ),
                      ),
                      title: Text(title),
                      subtitle: Text(topic!),
                      trailing: Text(newDate),
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
