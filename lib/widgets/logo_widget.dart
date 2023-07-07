import 'package:flutter/material.dart';

class CustAppLogo extends StatelessWidget {
  const CustAppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          'assets/logo/logo.png',
          height: 30,
          width: 30,
        ));
  }
}
