import 'package:restaurant_app/data/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;
  SharedPreferencesService(this._preferences);

  static const String _keyNotification = "MY_NOTIFICATION";
  static const String _keyTheme = "MY_THEME_BOOL";
  static const String _keyNotificationHour = "MY_NOTIFICATION_HOUR";
  static const String _keyNotificationMinute = "MY_NOTIFICATION_MINUTE";

  Future<void> setNotificationEnabled(bool enabled) async {
    await _preferences.setBool(_keyNotification, enabled);
  }

  bool getNotificationEnabled() {
    return _preferences.getBool(_keyNotification) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _preferences.setBool(_keyTheme, isDark);
  }

  bool getDarkMode() {
    return _preferences.getBool(_keyTheme) ?? true;
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    await _preferences.setInt(_keyNotificationHour, hour);
    await _preferences.setInt(_keyNotificationMinute, minute);
  }

  int getNotificationHour() {
    return _preferences.getInt(_keyNotificationHour) ?? 11;
  }

  int getNotificationMinute() {
    return _preferences.getInt(_keyNotificationMinute) ?? 0;
  }

  Future<void> saveSettingValue(Setting setting) async {
    await _preferences.setBool(_keyNotification, setting.notificationEnable);
    await _preferences.setBool(_keyTheme, setting.isDarkTheme);
    await _preferences.setInt(_keyNotificationHour, setting.notificationHour);
    await _preferences.setInt(
      _keyNotificationMinute,
      setting.notificationMinute,
    );
  }

  Setting getSettingValue() {
    return Setting(
      notificationEnable: getNotificationEnabled(),
      isDarkTheme: getDarkMode(),
      notificationHour: getNotificationHour(),
      notificationMinute: getNotificationMinute(),
    );
  }
}
