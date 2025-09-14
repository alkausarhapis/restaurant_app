import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/service/local_notifications_service.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationsService _notificationService;
  final SharedPreferencesService _preferencesService;
  final ApiService _apiService;

  static const int _dailyNotificationId = 1001;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  bool _hasPermission = false;

  LocalNotificationProvider(
    this._notificationService,
    this._preferencesService,
    this._apiService,
  );

  Future<void> init() async {
    await _notificationService.init();
    await _notificationService.configureLocalTimeZone();
    _isEnabled = _preferencesService.getNotificationEnabled();

    _hasPermission = await _checkPermissions();

    if (_isEnabled && _hasPermission) {
      await _scheduleIfNeeded();
    }

    notifyListeners();
  }

  Future<bool> _checkPermissions() async {
    try {
      final hasNotificationPermission = await _notificationService
          .requestPermission();
      final hasExactAlarmsPermission = await _notificationService
          .requestExactAlarmsPermission();
      return hasNotificationPermission && hasExactAlarmsPermission;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  Future<void> _scheduleIfNeeded() async {
    try {
      final pendingNotifications = await _notificationService
          .getPendingNotifications();
      final hasScheduledNotification = pendingNotifications.any(
        (notification) => notification.id == _dailyNotificationId,
      );

      if (!hasScheduledNotification) {
        await scheduleDailyLunchNotification();
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<bool> requestPermission() async {
    _hasPermission = await _checkPermissions();
    notifyListeners();
    return _hasPermission;
  }

  Future<void> setEnabled(bool value) async {
    final previousState = _isEnabled;

    _isEnabled = value;
    await _preferencesService.setNotificationEnabled(value);

    if (value && !previousState) {
      _hasPermission = await requestPermission();

      if (_hasPermission) {
        await scheduleDailyLunchNotification();
      } else {
        _isEnabled = false;
        await _preferencesService.setNotificationEnabled(false);
      }
    } else if (!value && previousState) {
      await cancelDailyNotification();
    }

    notifyListeners();
  }

  Future<void> scheduleDailyLunchNotification() async {
    if (!await _checkPermissions()) {
      debugPrint('Cannot schedule: missing permissions');
      return;
    }

    await cancelDailyNotification();

    final hour = _preferencesService.getNotificationHour();
    final minute = _preferencesService.getNotificationMinute();

    String? imagePath;
    String restaurantId = 'random';
    String restaurantName = 'Restaurant';
    String restaurantCity = '';

    try {
      final listResponse = await _apiService.getRestaurantList();
      final restaurants = listResponse.restaurants;
      if (restaurants.isNotEmpty) {
        final random = Random();
        final restaurant = restaurants[random.nextInt(restaurants.length)];

        restaurantId = restaurant.id;
        restaurantName = restaurant.name;
        restaurantCity = restaurant.city;

        final pictureId = restaurant.pictureId;
        if (pictureId.isNotEmpty) {
          final url =
              'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
          imagePath = await _downloadAndSaveImage(url, 'daily_restaurant.jpg');
        }
      }
    } catch (e) {
      throw Exception('Error getting image for notification: $e');
    }

    try {
      await _notificationService.scheduleDailyAtTime(
        id: _dailyNotificationId,
        title: 'Rekomendasi Restoran untukmu hari ini',
        body: restaurantCity.isNotEmpty
            ? '$restaurantName - $restaurantCity'
            : 'Tekan untuk melihat detailnya',
        hour: hour,
        minute: minute,
        payload: restaurantId,
        bigPictureFilePath: imagePath,
      );

      final pendingNotifications = await _notificationService
          .getPendingNotifications();
      final isScheduled = pendingNotifications.any(
        (notification) => notification.id == _dailyNotificationId,
      );

      if (!isScheduled) {
        debugPrint('Warning: Notification appears to be not scheduled');
      } else {
        debugPrint('Notification successfully scheduled for $hour:$minute');
      }
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }
  }

  Future<void> cancelDailyNotification() async {
    await _notificationService.cancelNotification(_dailyNotificationId);
  }

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> showPreviewNotification() async {
    try {
      final listResponse = await _apiService.getRestaurantList();
      final restaurants = listResponse.restaurants;
      if (restaurants.isEmpty) return;

      final random = Random();
      final restaurant = restaurants[random.nextInt(restaurants.length)];
      final id = restaurant.id;
      final name = restaurant.name;
      final city = restaurant.city;
      final pictureId = restaurant.pictureId;

      Uint8List? imageBytes;
      if (pictureId.isNotEmpty) {
        final url =
            'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        }
      }

      await _notificationService.showBigPicture(
        id: 9000,
        title: "Rekomendasi Restoran",
        body: '$name - $city',
        bigPictureBytes: imageBytes,
        payload: id,
      );
    } catch (e) {
      throw Exception('Failed to show preview notification: $e');
    }
  }

  Future<void> updateNotificationTime(int hour, int minute) async {
    if (_isEnabled && _hasPermission) {
      await scheduleDailyLunchNotification();
    }
  }
}
