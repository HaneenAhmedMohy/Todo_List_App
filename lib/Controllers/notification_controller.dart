import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:creiden_task/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  Future<void> scheduleNotification({required TodoItem item}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Replace with your own channel ID
      'channel_name', // Replace with your own channel name
      channelDescription:
          'channel_description', // Replace with your own channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    // Configure the notification
    int notificationId = item.id!; // Unique ID for the notification
    String notificationTitle = item.name;
    String notificationBody = item.description;
    if (item.date.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.from(item.date, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> deleteScheduledNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future<void> updateNotification({required TodoItem item}) async {
    // cncel notification
    await deleteScheduledNotification(item.id!);

    // Schedule the updated notification
    await scheduleNotification(item: item);
  }

  Future<void> clearAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
