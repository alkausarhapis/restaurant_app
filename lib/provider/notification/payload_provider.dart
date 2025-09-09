import 'package:flutter/foundation.dart';

class PayloadProvider extends ChangeNotifier {
  PayloadProvider({String? payload}) : _payload = payload;

  String? _payload;
  String? get payload => _payload;

  set payload(String? value) {
    _payload = value;
    notifyListeners();
  }

  void clear() {
    _payload = null;
    notifyListeners();
  }
}
