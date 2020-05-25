import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotification() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/launcher_icon");
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
}

Future<void> deleteNotification(final int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> deleteAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> scheduleNotification(
    int id, DateTime scheduledNotificationDateTime) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      enableVibration: true);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(id, 'Pomodoro is good...',
      '...on pizza!', scheduledNotificationDateTime, platformChannelSpecifics,
      androidAllowWhileIdle: true);
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {}

Future onSelectNotification(String payload) {}
