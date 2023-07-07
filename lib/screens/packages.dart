import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';

import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/utils/config.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  PackagesScreenState createState() => PackagesScreenState();
}

class PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return CustScaffold(
      // title: 'Packages',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Busy',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.5),
                      ),
                    ),
                    const Text(
                      'Put your money to work',
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PackagesWid(
                image: 'gift_1',
                color: accent.withOpacity(0.7),
                route: '/refer',
                text: 'Refer and receive gift',
              ),
              const SizedBox(height: 20),
              PackagesWid(
                image: 'money_1',
                color: green.withOpacity(0.4),
                route: '/investments',
                text: 'Invest and earn returns',
              ),
              const SizedBox(height: 20),
              PackagesWid(
                image: 'cal_1',
                color: blue.withOpacity(0.4),
                route: '/subscribe',
                text: 'Subscribe for daily signals',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PackagesWid extends StatelessWidget {
  const PackagesWid({
    Key? key,
    required this.text,
    required this.image,
    required this.route,
    required this.color,
  }) : super(key: key);

  final String text;
  final String image;
  final String route;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              height: 100,
              child: Image.asset('assets/images/$image.png'),
            ),
            SizedBox(
              width: 130,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
