import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'default_channel_id';
  static const String _channelName = 'Default Channel';
  static const String _channelDescription =
      'This channel is used for basic notifications';

  // Initialize the notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create the notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Request exact alarm permission (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      const MethodChannel platform =
          MethodChannel("flutter_local_notifications_exact_alarm");

      final bool exactAlarmGranted =
          await platform.invokeMethod<bool>('requestExactAlarmPermission') ??
              false;

      return exactAlarmGranted;
    }
    return true; // Permissions not needed for other platforms
  }

  // Schedule a notification with dynamic title, body, hour, and minute
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final permissionGranted = await requestExactAlarmPermission();
    if (!permissionGranted) {
      print('Exact alarm permission not granted.');
      return;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('Notification scheduled: "$title" - "$body" at $hour:$minute');
  }

  // Helper to get the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(now);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    print('scheduled time: $scheduledDate');
    if (scheduledDate.isBefore(now)) {
      print('here');
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
