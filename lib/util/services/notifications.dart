import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Notifications
class Notifications {
  ///Notifications Service
  static final _notifService = FlutterLocalNotificationsPlugin();

  ///Setup Notification Service
  static Future<void> setupService() async {
    //Android Init Settings
    const androidSettings = AndroidInitializationSettings("ic_launcher");

    //iOS Init Settings
    const iOSSettings = DarwinInitializationSettings();

    //Initialize Service
    await _notifService.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      ),
    );
  }

  ///Send Notification
  static Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    //Android Notif Details
    const androidDetails =
        AndroidNotificationDetails("Palhetas_14", "Palhetas");

    //iOS Notif Details
    const iOSDetails = DarwinNotificationDetails();

    //Show Notification
    await _notifService.show(
      Random().nextInt(14),
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      ),
    );
  }
}
