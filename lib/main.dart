import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/events/events.dart';
import 'package:palhetas/pages/intro/intro.dart';
import 'package:palhetas/pages/news/item.dart';
import 'package:palhetas/pages/palhetas.dart';
import 'package:palhetas/util/services/main.dart';
import 'package:palhetas/util/theming/themes.dart';

void main() async {
  //App Services
  await MainServices.init();

  //Initial Route
  final initialRoute = await MainServices.initialRoute();

  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          getPages: [
            GetPage(name: "/", page: () => const Palhetas()),
            GetPage(name: "/intro", page: () => const Intro()),
            GetPage(
              name: "/article/:id",
              page: () => NewsItem(
                articleID: Get.parameters["id"]!,
              ),
            ),
          ],
          initialRoute: initialRoute,
        );
      },
    ),
  );
}
