import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palhetas/pages/home/home.dart';
import 'package:palhetas/util/theming/controller.dart';
import 'package:palhetas/util/theming/themes.dart';

void main() async {
  //Ensure Everything is Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Theme
  final appTheme = await AdaptiveTheme.getThemeMode();

  ThemeController.setStatusAndNav(
    themeMode: appTheme ?? AdaptiveThemeMode.system,
  );

  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light(),
      dark: Themes.dark(),
      initial: appTheme ?? ThemeController.systemTheme(),
      builder: (light, dark) => MaterialApp(
        home: Home(
          themeMode: appTheme ?? ThemeController.systemTheme(),
        ),
        theme: light,
        darkTheme: dark,
      ),
    ),
  );
}
