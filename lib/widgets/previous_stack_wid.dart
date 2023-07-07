import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class PreviousStackWid extends StatelessWidget {
  const PreviousStackWid({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(IconlyLight.arrowLeft),
            Text('Previous'),
          ],
        ),
      ),
    );
  }
}
