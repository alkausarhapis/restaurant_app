import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/static/global_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;
  RestaurantDetailProvider(this._apiService);

  ResultState<RestaurantDetail> _state = ResultState.none();
  ResultState<RestaurantDetail> get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = ResultState.loading();
    notifyListeners();

    try {
      final resp = await _apiService.getRestaurantDetail(id);

      if (resp.error) {
        _state = ResultState.error(resp.message);
      } else {
        _state = ResultState.success(resp.restaurant);
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
