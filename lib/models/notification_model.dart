import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';

class NotificationModelFunction{
  NotificationModelFunction();



  void showNotification(int id,String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,

        channelKey: 'recap_channel',
        title: title,
        body: body,
        wakeUpScreen: true,
        icon: 'resource://drawable/panther_logo_transparent_117x117',

      ),
    );
  }

  void rescheduleTask(String taskName, Duration delay) {
    Workmanager().registerOneOffTask(
      '1',
      taskName,
      initialDelay: delay,
    );
  }


}

