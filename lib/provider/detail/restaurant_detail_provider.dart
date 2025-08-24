import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;
  RestaurantDetailProvider(this._apiService);

  RestaurantDetailResultState _state = RestaurantDetailNoneState();
  RestaurantDetailResultState get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = RestaurantDetailResultLoading();
      notifyListeners();

      final restaurant = await _apiService.getRestaurantDetail(id);

      if (restaurant.error) {
        _state = RestaurantDetailErrorState(restaurant.message);
        notifyListeners();
      } else {
        _state = RestaurantDetailLoadedState(restaurant.restaurant);
        notifyListeners();
      }
    } on SocketException {
      _state = RestaurantDetailNoInternetState();
      notifyListeners();
    } on TimeoutException {
      _state = RestaurantDetailNoInternetState();
      notifyListeners();
    } catch (e) {
      _state = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
