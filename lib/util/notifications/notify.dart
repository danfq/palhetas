import 'package:awesome_notifications/awesome_notifications.dart';

///Notification Methods
class Notify {
  static Future<void> sendNotification({
    required String notificationTitle,
  }) async {
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        } else {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 14,
              channelKey: "palhetas_channel",
              wakeUpScreen: true,
              title: "Nova Notícia",
              body: notificationTitle,
              notificationLayout: NotificationLayout.BigText,
            ),
          );
        }
      },
    );
  }
}
