import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/service/local_notifications_service.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationsService _notif;
  final SharedPreferencesService _prefs;
  final ApiService _api;

  LocalNotificationProvider(this._notif, this._prefs, this._api);

  bool _enabled = false;
  bool get enabled => _enabled;

  // Single ID untuk repeat harian jam 06:30
  static const int _dailyId = 63001;

  Future<void> init() async {
    await _notif.init();
    await _notif.configureLocalTimeZone();
    _enabled = _prefs.getNotificationEnabled();
    notifyListeners();
  }

  Future<void> requestPermission() async {
    await _notif.requestAndroidPermissionIfNeeded();
    // (opsional) beberapa device/Android 12+ perlu exact-alarm setting:
    await _notif.requestExactAlarmsPermission();
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await _prefs.setNotificationEnabled(value);
    notifyListeners();

    if (value) {
      await scheduleDaily0630();
    } else {
      await cancelDaily();
    }
  }

  /// Jadwalkan harian 06:30. Konten statis; payload = 'random'.
  Future<void> scheduleDaily0630() async {
    await cancelDaily();

    // (opsional) jika ingin tampil big picture statis di notifikasi
    String? bigPath;
    try {
      final listResp = await _api.getRestaurantList();
      final list = listResp.restaurants;
      if (list.isNotEmpty) {
        final rnd = Random();
        final pick = list[rnd.nextInt(list.length)];
        final pictureId = pick.pictureId;
        if (pictureId.isNotEmpty) {
          final url =
              'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
          bigPath = await _downloadAndSave(url, 'daily_static.jpg');
        }
      }
    } catch (_) {
      // abaikan jika gagal unduh gambar
    }

    await _notif.zonedScheduleDailyAtTime(
      id: _dailyId,
      title: 'Rekomendasi restoran hari ini',
      body: 'Ketuk untuk melihat rekomendasi terbaru',
      hour: 6,
      minute: 35,
      payload: 'random', // sentinel → di-listener akan fetch random terbaru
      bigPictureFilePath: bigPath, // boleh null untuk notifikasi tanpa gambar
    );
  }

  Future<void> cancelDaily() async {
    await _notif.cancel(_dailyId);
  }

  Future<String> _downloadAndSave(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final resp = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(resp.bodyBytes);
    return filePath;
  }

  /// Preview sekarang: ambil random + tampilkan Big Picture.
  Future<void> previewNow() async {
    final listResp = await _api.getRestaurantList();
    final list = listResp.restaurants;
    if (list.isEmpty) return;

    final rnd = Random();
    final pick = list[rnd.nextInt(list.length)];
    final id = pick.id; // String
    final name = pick.name;
    final city = pick.city;
    final pictureId = pick.pictureId;

    Uint8List? bigBytes;
    if (pictureId.isNotEmpty) {
      final url =
          'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        bigBytes = resp.bodyBytes;
      }
    }

    await _notif.showBigPicture(
      id: 99999,
      title: 'Preview — $name',
      body: city,
      bigPictureBytes: bigBytes,
      payload: id,
    );
  }
}
