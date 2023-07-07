import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/controllers/classes_ctrl.dart';

import 'package:forex_guru/screens/courses_list.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../backends/all_repos.dart';
import '../utils/strings.dart';
import '../widgets/lazy_load_wid.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  Widget build(BuildContext context) {
    final ClassesCtrl classesCtrl = Get.put(ClassesCtrl());
    final AllRepos allRepos = AllRepos();

    classesCtrl.loading.value = false;
    return CustScaffold(
      onRefresh: () async => {classesCtrl.getAllClasses()},
      // title: 'Classes',
      // actions: [
      //   IconButton(onPressed: () {}, icon: const Icon(IconlyLight.download)),
      // ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://media-exp1.licdn.com/dms/image/C4D1BAQFxX3_TWO754g/company-background_10000/0/1575424046389?e=2159024400&v=beta&t=brdhX-sTVgCc87_wVejf2ErF1eeyuL7mP83467MmoZU',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 50,
                  child: CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconlyLight.download),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Understand the Market',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: GoogleFonts.aBeeZee().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                      'Enroll in our top notch classes to get indepth insight about the forex market'),
                  const SizedBox(height: 20),
                  FutureBuilder<Map>(
                      future: classesCtrl.getAllClasses(),
                      builder: (context, snapshot) {
                        return allRepos.snapshotFuture(
                          snapshot,
                          Obx(
                            () => LazyLoadWid(
                              isLoading: classesCtrl.isLoading.value,
                              data: snapshot.data == null
                                  ? []
                                  : snapshot.data!['classes'],
                              lData: classesCtrl.lData,
                              onEndOfPage: () => classesCtrl.loadMore(false),
                              padding: const EdgeInsets.only(bottom: 100),
                              height: 0.6,
                              itemBuilder: (context, index) {
                                var dt = snapshot.data!['classes'];
                                List uDt = snapshot.data!['u_class'];
                                if (uDt.contains(dt[index]['reference'])) {
                                  Map data = dt[index];
                                  data['enrolled'] = true;
                                  return ClassWid(
                                    data: data,
                                    title: dt[index]['title'],
                                    desc: dt[index]['description'],
                                    image: dt[index]['cover_image'],
                                    price: dt[index]['amount'].toString(),
                                    hasEnrolled: true,
                                  );
                                } else {
                                  Map data = dt[index];
                                  data['enrolled'] = false;
                                  return ClassWid(
                                    data: dt[index],
                                    title: dt[index]['title'],
                                    desc: dt[index]['description'],
                                    image: dt[index]['cover_image'],
                                    price: dt[index]['amount'].toString(),
                                    hasEnrolled: false,
                                    onTap: () => popConfirmation(
                                        dt[index], allRepos, classesCtrl),
                                  );
                                }
                              },
                            ),
                          ),
                          hasBack: false,
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  popConfirmation(data, AllRepos allRepos, ClassesCtrl classesCtrl) {
    return allRepos.showPopUp(
      const Text('Are you sure you want to Enroll for this course?'),
      [
        CupertinoButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'class_reference': data['reference'],
              };
              classesCtrl.setLoading(true);
              await allRepos.enroll(body);
              classesCtrl.setLoading(false);

              setState(() {});
            } catch (e) {
              allRepos.showFlush(
                e.toString(),
                backgroundColor: red,
              );
            }
          },
        ),
        CupertinoButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
      [
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            try {
              Map body = {
                'class_reference': data['reference'],
              };
              classesCtrl.setLoading(true);
              await allRepos.enroll(body);
              classesCtrl.setLoading(false);

              setState(() {});
            } catch (e) {
              allRepos.showFlush(
                e.toString(),
                backgroundColor: red,
              );
            }
          },
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

class ClassWid extends StatelessWidget {
  const ClassWid({
    Key? key,
    required this.title,
    required this.desc,
    required this.image,
    required this.price,
    this.isContents = false,
    this.hasEnrolled,
    this.onTap,
    required this.data,
  }) : super(key: key);

  final String title;
  final String desc;
  final String image;
  final String price;
  final bool? isContents;
  final bool? hasEnrolled;
  final Function()? onTap;
  final Map data;
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;

    final settingsBx = Hive.box(settings);
    var currRate = settingsBx.get(activeRate) ?? defaultRate;
    String curr = settingsBx.get(activeCurrency) ?? defaultCurrency;

    String newPrice = (double.parse(price) * currRate).toStringAsFixed(2);
    return Column(
      children: [
        InkWell(
          onTap: isContents!
              ? null
              : () => Get.to(() => CoursesList(
                    data: data,
                  )),
          child: SizedBox(
            width: med.width,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    height: 120,
                    width: 120,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.aBeeZee().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        isContents!
                            ? GestureDetector(
                                onTap: () => {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Play',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Feather.video,
                                        color: white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: hasEnrolled! ? null : onTap,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        hasEnrolled! ? grey : Colors.redAccent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    hasEnrolled!
                                        ? 'Enrolled'
                                        : 'Enroll for $curr $newPrice',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: white,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: accent,
        ),
      ],
    );
  }
}
