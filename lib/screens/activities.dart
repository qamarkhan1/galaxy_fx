import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivitiesScreen extends GetxController {
  ActivitiesScreen({Key? key});
  Widget build(BuildContext context) {
    return CustScaffold(
      title: '',
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: 10,
          itemBuilder: (_, int index) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/1280px-Flag_of_Europe.svg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: blue.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EUR/USD',
                            style: TextStyle(
                              fontSize: 20,
                              color: white,
                            ),
                          ),
                          Text(
                            '-0.16',
                            style: TextStyle(
                              fontSize: 20,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-0.16',
                            style: TextStyle(
                              fontSize: 20,
                              color: white,
                            ),
                          ),
                          const SizedBox(
                            height: 120,
                            width: 120,
                            // color: primaryColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
