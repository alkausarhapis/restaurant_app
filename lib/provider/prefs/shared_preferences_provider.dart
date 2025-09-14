import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/setting.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;
  SharedPreferencesProvider(this._service) {
    _setting = _service.getSettingValue();
  }

  String _message = "";
  String get message => _message;

  late Setting _setting;
  Setting get setting => _setting;

  bool get isNotificationEnabled => _setting.notificationEnable;
  bool get isDarkMode => _setting.isDarkTheme;
  int get notificationHour => _setting.notificationHour;
  int get notificationMinute => _setting.notificationMinute;

  String get notificationTimeString {
    final hour = notificationHour.toString().padLeft(2, '0');
    final minute = notificationMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> saveSettingValue(Setting value) async {
    try {
      await _service.saveSettingValue(value);
      _setting = value;
      _message = "Setting saved!";
    } catch (e) {
      _message = "ERR: Save setting failed $e";
    } finally {
      notifyListeners();
    }
  }

  Future<void> setNotification(bool enabled) async {
    await _service.setNotificationEnabled(enabled);
    _setting = (_setting).copyWith(notificationEnable: enabled);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    await _service.setDarkMode(isDark);
    _setting = (_setting).copyWith(isDarkTheme: isDark);
    notifyListeners();
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    await _service.setNotificationTime(hour, minute);
    _setting = (_setting).copyWith(
      notificationHour: hour,
      notificationMinute: minute,
    );
    notifyListeners();
  }
}
