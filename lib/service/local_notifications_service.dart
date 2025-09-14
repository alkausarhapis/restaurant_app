import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class LocalNotificationsService {
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const init = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(
      init,
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null && payload.isNotEmpty) {
          selectNotificationStream.add(payload);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'restaurant_channel',
      'Restaurant Recommendations',
      description: 'Daily restaurant recommendations',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<bool> requestPermission() async {
    final impl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final enabled =
        await (impl?.areNotificationsEnabled() ?? Future.value(false));
    if (enabled!) return true;
    return await impl?.requestNotificationsPermission() ?? Future.value(false);
  }

  Future<bool> requestExactAlarmsPermission() async {
    final impl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await impl?.requestExactAlarmsPermission() ?? Future.value(false);
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final name = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(name));
  }

  Future<void> showBigPicture({
    required int id,
    required String title,
    required String body,
    Uint8List? largeIconBytes,
    Uint8List? bigPictureBytes,
    String? payload,
  }) async {
    final style = bigPictureBytes != null
        ? BigPictureStyleInformation(
            ByteArrayAndroidBitmap(bigPictureBytes),
            largeIcon: largeIconBytes != null
                ? ByteArrayAndroidBitmap(largeIconBytes)
                : null,
            contentTitle: title,
            summaryText: body,
            hideExpandedLargeIcon: false,
          )
        : null;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'restaurant_channel',
        'Restaurant Recommendations',
        channelDescription: 'Daily restaurant recommendations',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: style,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    String? bigPictureFilePath,
    Uint8List? largeIconBytes,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final style = bigPictureFilePath != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(bigPictureFilePath),
            largeIcon: largeIconBytes != null
                ? ByteArrayAndroidBitmap(largeIconBytes)
                : null,
            contentTitle: title,
            summaryText: body,
            hideExpandedLargeIcon: false,
          )
        : null;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'restaurant_channel',
        'Restaurant Recommendations',
        channelDescription: 'Daily restaurant recommendations',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: style,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> cancelNotification(int id) =>
      flutterLocalNotificationsPlugin.cancel(id);

  Future<void> cancelAllNotifications() =>
      flutterLocalNotificationsPlugin.cancelAll();
}
