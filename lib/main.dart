import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:palhetas/pages/home/home.dart';
import 'package:palhetas/util/theming/controller.dart';
import 'package:palhetas/util/theming/themes.dart';
import 'package:palhetas/values/colors.dart';

void main() async {
  //Ensure Everything is Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Theme
  final appTheme = await AdaptiveTheme.getThemeMode();

  ThemeController.setStatusAndNav(
    themeMode: appTheme ?? AdaptiveThemeMode.system,
  );

  //Notifications
  AwesomeNotifications().initialize(
    "resource://drawable/logo", //Use Default Icon
    [
      NotificationChannel(
        channelGroupKey: "palhetas_group",
        channelKey: "palhetas_channel",
        channelName: "Pahetas Notifications",
        channelDescription: "Notificaations for Palhetas",
        defaultColor: AppColors.mddmPalette["accent_mati"],
        ledColor: AppColors.mddmPalette["accent_dan"],
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: "palhetas_group",
        channelGroupName: "Palhetas Group",
      )
    ],
    debug: true,
  );

  AwesomeNotifications().actionStream.listen(
    (ReceivedNotification receivedNotification) {
      print(receivedNotification.title!);
    },
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
