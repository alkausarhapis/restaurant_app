import 'package:flutter/material.dart';

class IndexNavProvider extends ChangeNotifier {
  int _idxBottomNavbar = 0;

  int get idxBottomNavbar => _idxBottomNavbar;

  set setIdxBottomNavbar(int value) {
    _idxBottomNavbar = value;
    notifyListeners();
  }
}
