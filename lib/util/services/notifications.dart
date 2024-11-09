import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:palhetas/util/services/fetch.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

///Notifications
class Notifications {
  ///Notifications Service
  static final _notifService = FlutterLocalNotificationsPlugin();

  ///WorkManager
  static final _workManager = Workmanager();

  ///Request Permission
  static Future<void> _requestPermission() async {
    await Permission.notification.request().then((result) {
      debugPrint("[NOTIF_SERVICE] Permission: $result.");
    });
  }

  ///Initialize WorkManager
  static Future<void> _initWorkManager() async {
    await _workManager.initialize(
      fetchInBackground,
      isInDebugMode: true,
    );

    //Debug
    debugPrint("[NOTIF_SERVICE] Initialized WorkManager.");
  }

  ///Setup Notification Service
  static Future<void> setupService() async {
    //Android Init Settings
    const androidSettings = AndroidInitializationSettings("logo");

    //iOS Init Settings
    const iOSSettings = DarwinInitializationSettings();

    //Request Permission
    await _requestPermission();

    //Initialize WorkManager
    await _initWorkManager();

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
    const androidDetails = AndroidNotificationDetails(
      "Palhetas_14",
      "Palhetas",
    );

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
