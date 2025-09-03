import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/static/global_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _api;
  RestaurantSearchProvider(this._api);

  ResultState<List<Restaurant>> _state = ResultState.none();
  ResultState<List<Restaurant>> get state => _state;

  Future<void> searchRestaurants(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      _state = ResultState.none();
      notifyListeners();
      return;
    }

    _state = ResultState.loading();
    notifyListeners();

    try {
      final res = await _api.searchRestaurants(q);
      final results = res.restaurants;

      if (results.isEmpty) {
        _state = ResultState.success(<Restaurant>[]);
      } else {
        _state = ResultState.success(results);
      }
    } on SocketException {
      _state = ResultState.noInternet();
    } on TimeoutException {
      _state = ResultState.noInternet();
    } catch (e) {
      _state = ResultState.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _state = ResultState.none();
    notifyListeners();
  }
}
