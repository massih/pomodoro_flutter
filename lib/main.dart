import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/screen/pomodoro.dart';
//
//void main() => () {
////      await initiateLocalNotification();
//      return runApp(MyApp());
//    };
void main() => runApp(MyApp());

//Future initiateLocalNotification() async {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//  var initializationSettingsIOS = IOSInitializationSettings(
//      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//  var initializationSettings = InitializationSettings(
//      initializationSettingsAndroid, initializationSettingsIOS);
//  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//      onSelectNotification: selectNotification);
//}
//
//Future selectNotification(String payload) async {
//  if (payload != null) {
//    debugPrint('notification payload: ' + payload);
//  }
//  await Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//  );
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Pomodoro(),
    );
  }
}