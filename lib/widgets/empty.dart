import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:get/route_manager.dart';

class EmptyWid extends StatelessWidget {
  const EmptyWid({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.svg,
    this.height,
    this.hasBack = true,
  }) : super(key: key);

  final String svg;
  final String title;
  final String subtitle;
  final double? height;
  final bool? hasBack;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/svgs/$svg.svg",
            height: height ?? 350,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
          ),
          const SizedBox(height: 20),
          hasBack!
              ? CustButton(
                  onTap: () => Get.back(),
                  title: 'Go Back',
                  width: 200,
                  isHollow: true,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
