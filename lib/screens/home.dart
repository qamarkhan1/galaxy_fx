import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:forex_guru/screens/more.dart';
import 'package:forex_guru/screens/classes.dart';
import 'package:forex_guru/screens/front_screen.dart';
import 'package:forex_guru/screens/packages.dart';
import 'package:forex_guru/screens/signals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentIndex = 0;

  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> tabs = [
    const FrontScreen(),
    const SignalsScreen(),
    const ClassesScreen(),
    const PackagesScreen(),
    const AccountsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
          body: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).hintColor,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.activity),
                    activeIcon: Icon(IconlyBold.activity),
                    label: ('Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.chart),
                    activeIcon: Icon(IconlyBold.chart),
                    label: 'Signals',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.video),
                    activeIcon: Icon(IconlyBold.video),
                    label: ('Classes'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.work),
                    activeIcon: Icon(IconlyBold.work),
                    label: ('Packages'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.discovery),
                    activeIcon: Icon(IconlyBold.discovery),
                    label: ('More'),
                  ),
                ],
              ),
              tabBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const FrontScreen();
                  case 1:
                    return const SignalsScreen();

                  case 2:
                    return const ClassesScreen();

                  case 3:
                    return const PackagesScreen();

                  case 4:
                    return const AccountsScreen();

                  default:
                    return const SignalsScreen();
                }
              }));
    } else {
      return WillPopScope(
        onWillPop: pop,
        child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          body: IndexedStack(
            index: currentIndex,
            children: tabs,
          ),

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).hintColor,
            // unselectedItemColor: roseQuartz,
            // backgroundColor: Theme.of(context).primaryColor,
            currentIndex: currentIndex,
            onTap: onTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.activity),
                activeIcon: Icon(IconlyBold.activity),
                label: ('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.chart),
                activeIcon: Icon(IconlyBold.chart),
                label: 'Signals',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.video),
                activeIcon: Icon(IconlyBold.video),
                label: ('Classes'),
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.work),
                activeIcon: Icon(IconlyBold.work),
                label: ('Packages'),
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.discovery),
                activeIcon: Icon(IconlyBold.discovery),
                label: ('More'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> pop() async {
    return false;
  }
}
