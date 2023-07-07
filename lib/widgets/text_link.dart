import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';

class TextLinkWid extends StatelessWidget {
  const TextLinkWid({
    Key? key,
    this.onTap,
    required this.title,
    this.url,
    this.color,
    this.size,
  }) : super(key: key);
  final String? title;
  final String? url;
  final void Function()? onTap;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    return InkWell(
      onTap: url != null ? () => allRepos.launchUrlFxn(url!) : onTap,
      child: Text(
        title!,
        style: TextStyle(color: color ?? blue, fontSize: size ?? 14.0),
      ),
    );
  }
}
