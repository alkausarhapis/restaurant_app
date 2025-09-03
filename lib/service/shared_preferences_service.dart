import 'package:restaurant_app/data/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;
  SharedPreferencesService(this._preferences);

  static const String _keyNotification = "MY_NOTIFICATION";
  static const String _keyTheme = "MY_THEME_BOOL";

  Future<void> setNotificationEnabled(bool enabled) async {
    await _preferences.setBool(_keyNotification, enabled);
  }

  bool getNotificationEnabled() {
    return _preferences.getBool(_keyNotification) ?? true;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _preferences.setBool(_keyTheme, isDark);
  }

  bool getDarkMode() {
    return _preferences.getBool(_keyTheme) ?? true;
  }

  Future<void> saveSettingValue(Setting setting) async {
    await _preferences.setBool(_keyNotification, setting.notificationEnable);
    await _preferences.setBool(_keyTheme, setting.isDarkTheme);
  }

  Setting getSettingValue() {
    return Setting(
      notificationEnable: getNotificationEnabled(),
      isDarkTheme: getDarkMode(),
    );
  }
}
