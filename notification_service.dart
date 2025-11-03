import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../models/alarm.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();


  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();


  Future<void> init() async {
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }


  Future<void> scheduleNotification(Alarm alarm) async {
    final scheduled = tz.TZDateTime.from(alarm.scheduledAt, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return; // don't schedule past


    await _plugin.zonedSchedule(
      alarm.id,
      'Relax Reminder',
      alarm.title,
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails('alarm_channel', 'Alarms', channelDescription: 'Alarm notifications', importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }


  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}