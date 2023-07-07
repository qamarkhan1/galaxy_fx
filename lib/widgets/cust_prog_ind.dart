import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';

class CustProgIndicator extends StatelessWidget {
  const CustProgIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? const CupertinoActivityIndicator()
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accent)),
    );
  }
}
