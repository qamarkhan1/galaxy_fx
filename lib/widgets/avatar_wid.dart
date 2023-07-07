import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();
    String avatar = allRepos.avatarManipulation(name);

    return CircleAvatar(
      radius: 22,
      backgroundColor: white,
      child: CircleAvatar(
        child: Text(
          avatar.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
