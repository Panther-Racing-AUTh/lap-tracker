import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController {
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher', // Replace with your app icon
      [
        NotificationChannel(
          channelKey: 'scheduled_notification',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          defaultColor: Colors.red,
          ledColor: Colors.red,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          vibrationPattern: Int64List(2),
          ledOnMs: 1000,
          ledOffMs: 500,
          enableLights: true,
          enableVibration: true,
        ),
      ],
      debug: true,
    );
  }

  static Future<void> createNewNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    int? day,
    int? month,
    int? year,
    int? hour,
    int? minute,
    int? second,
    Color? color,
  }) async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          title: title,
          body: body,
          channelKey: 'scheduled_notification',
          displayOnBackground: true,
          displayOnForeground: true,
          notificationLayout: NotificationLayout.BigText,
          wakeUpScreen: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: '30MIN',
            label: 'Remind in 30 min',
            actionType: ActionType.SilentAction,
          ),
          NotificationActionButton(
            key: '1HOUR',
            label: 'Remind in 1 hour',
            actionType: ActionType.SilentAction,
          ),
        ],
      );
    } else {
      // Handle case where permissions are not granted
      print('Notification permissions are not granted.');
    }
  }
}
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Initialize notification permissions
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
    await NotificationController.initializeLocalNotifications();
  }

  void _sendNotification() {
    DateTime now = DateTime.now().add(Duration(minutes: 1));

    NotificationController.createNewNotification(
      body: 'Body of the notification',
      title: 'Title of the notification',
      id: Random().nextInt(100),
      day: now.day,
      month: now.month,
      year: now.year,
      hour: now.hour,
      minute: now.minute,
      second: now.second,
      color: Colors.deepPurple,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _sendNotification,
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationPage(),
    );
  }
}
