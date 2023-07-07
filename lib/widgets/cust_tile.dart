import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';

class CustTile extends StatelessWidget {
  const CustTile({
    Key? key,
    this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final IconData? icon;
  final String title;
  final Function()? onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon != null
          ? Icon(
              icon,
              color: primaryColor,
            )
          : null,
      trailing: trailing,
      title: Text(title),
    );
  }
}
