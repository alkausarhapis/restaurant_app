import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/static/global_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiServices;
  RestaurantListProvider(this._apiServices);

  ResultState<List<Restaurant>> _resultState = ResultState.none();
  ResultState<List<Restaurant>> get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = ResultState.loading();
      notifyListeners();

      final restaurantList = await _apiServices.getRestaurantList();

      if (restaurantList.error) {
        _resultState = ResultState.error(restaurantList.message);
      } else {
        _resultState = ResultState.success(restaurantList.restaurants);
      }
    } on SocketException {
      _resultState = ResultState.noInternet();
    } on TimeoutException {
      _resultState = ResultState.noInternet();
    } catch (e) {
      _resultState = ResultState.error(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
