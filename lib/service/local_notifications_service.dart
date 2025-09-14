import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Stream payload untuk didengar di UI (tanpa rootNavKey).
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
        debugPrint("Foreground notification payload: $payload"); // Add this
        if (payload != null && payload.isNotEmpty) {
          selectNotificationStream.add(payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: _tapFromBackground,
    );

    const ch = AndroidNotificationChannel(
      'daily_restaurant_channel',
      'Daily Restaurant',
      description: 'Daily random restaurant reminder',
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(ch);
  }

  // Android 13+ permission (sesuai pola yang kamu minta)
  Future<bool> requestAndroidPermissionIfNeeded() async {
    final impl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final enabled =
        await (impl?.areNotificationsEnabled() ?? Future.value(false));
    if (enabled!) return true;
    return await impl?.requestNotificationsPermission() ?? Future.value(false);
  }

  // Beberapa device/Android 12+ perlu akses exact alarm (mengarah ke settings).
  Future<bool> requestExactAlarmsPermission() async {
    final impl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await impl?.requestExactAlarmsPermission() ?? Future.value(false);
  }

  // Wajib sebelum zonedSchedule
  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final name = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(name));
  }

  // Notifikasi Big Picture instan (untuk preview)
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
        'daily_restaurant_channel',
        'Daily Restaurant',
        channelDescription: 'Daily random restaurant reminder',
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

  /// Repeat harian exact di jam [hour]:[minute] lokal.
  /// Catatan: konten notifikasi akan statis (pakai payload 'random' sebagai sentinel).
  Future<void> zonedScheduleDailyAtTime({
    required int id,
    required String title,
    required String body,
    required int hour, // contoh: 6
    required int minute, // contoh: 30
    String? payload,
    String? bigPictureFilePath,
    Uint8List? largeIconBytes,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
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
        'daily_restaurant_channel',
        'Daily Restaurant',
        channelDescription: 'Daily random restaurant reminder',
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
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repeat harian
      payload: payload,
    );
  }

  Future<List<PendingNotificationRequest>> pending() =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> cancel(int id) => flutterLocalNotificationsPlugin.cancel(id);
  Future<void> cancelAll() => flutterLocalNotificationsPlugin.cancelAll();
}

@pragma('vm:entry-point')
void _tapFromBackground(NotificationResponse resp) {
  final payload = resp.payload;
  debugPrint("Background notification payload: $payload"); // Add this
  if (payload != null && payload.isNotEmpty) {
    selectNotificationStream.add(payload);
  }
}
