import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _api;
  RestaurantSearchProvider(this._api);

  RestaurantListResultState resultState = RestaurantListNoneState();
  List<Restaurant> _results = [];
  String message = '';

  Future<void> searchRestaurants(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      _results = [];
      resultState = RestaurantListNoneState();
      notifyListeners();
      return;
    }

    resultState = RestaurantListLoadingState();
    notifyListeners();

    try {
      final res = await _api.searchRestaurants(q);
      _results = res.restaurants;

      if (_results.isEmpty) {
        resultState = RestaurantListEmptyState();
      } else {
        resultState = RestaurantListLoadedState(_results);
      }
    } on SocketException {
      resultState = RestaurantListNoInternetState();
    } on TimeoutException {
      resultState = RestaurantListNoInternetState();
    } catch (e) {
      resultState = RestaurantListErrorState(e.toString());
      message = 'Error during search: ${e.toString()}';
    }

    notifyListeners();
  }

  void reset() {
    _results = [];
    resultState = RestaurantListNoneState();
    message = '';
    notifyListeners();
  }
}
