import 'dart:io';

import 'package:fluro/fluro.dart' as route;
import 'package:flutter/material.dart';
import 'package:forex_guru/screens/investments.dart';
import 'package:forex_guru/screens/refer.dart';
import 'package:forex_guru/screens/signals.dart';
import 'package:forex_guru/screens/subscribe.dart';

class FluroRouter {
  static final router = route.FluroRouter();

  //! Sign Screen
  static route.Handler signHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SignalsScreen();
  });

  //! Investment Screen
  static route.Handler investmentHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const InvestmentsScreen();
  });

  //! Refer Screen
  static route.Handler referHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const ReferScreen();
  });

  //! Refer Screen
  static route.Handler subscribeHandler = route.Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SubscribeScreen();
  });

  static void setupRouter() {
    //! Home
    router.define(
      '/sign-screen',
      handler: signHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! investments
    router.define(
      '/investments',
      handler: investmentHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! refer
    router.define(
      '/refer',
      handler: referHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );

    //! subscribe
    router.define(
      '/subscribe',
      handler: subscribeHandler,
      transitionType: Platform.isIOS
          ? route.TransitionType.cupertinoFullScreenDialog
          : route.TransitionType.native,
    );
  }
}
