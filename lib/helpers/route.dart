import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/views/screens/splash.dart';

class AppRoutes {
  static String splash = "/splash";
  static String app = "/app";

  static Map<String, Widget> routeWidgets = {
    splash: const Splash(),
  };

  static List<GetPage> pages = [
    ...routeWidgets.entries.map(
      (e) => GetPage(name: e.key, page: () => e.value),
    ),
  ];
}
