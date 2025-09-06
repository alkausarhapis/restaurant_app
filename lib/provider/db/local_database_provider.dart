import 'package:flutter/material.dart';
import 'package:restaurant_app/data/local/sqflite_service.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqfliteService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<RestaurantDetail>? _favoriteRestaurants;
  List<RestaurantDetail>? get favoriteRestaurants => _favoriteRestaurants;

  RestaurantDetail? _restaurantDetail;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  // Insert or update restaurant to favorites.
  Future<void> addToFavorite(RestaurantDetail restaurant) async {
    try {
      await _service.upsertFavorite(restaurant);
      _message = "${restaurant.name} added to favorites";
    } catch (e) {
      _message = "Failed to add favorite: $e";
    } finally {
      notifyListeners();
    }
  }

  // Load all favorited restaurants.
  Future<void> loadAllFavorites() async {
    try {
      _favoriteRestaurants = await _service.getTableFavoriteRestaurant();
      _restaurantDetail = null;
      _message = "Favorites loaded";
    } catch (e) {
      _message = "Failed to load favorites: $e";
    } finally {
      notifyListeners();
    }
  }

  // Load a single restaurant detail by ID.
  Future<void> loadFavoriteById(String id) async {
    try {
      _restaurantDetail = await _service.getDetailRelationId(id);
      _message = _restaurantDetail != null
          ? "Detail loaded"
          : "Favorite not found";
    } catch (e) {
      _message = "Failed to load detail: $e";
    } finally {
      notifyListeners();
    }
  }

  // Remove a restaurant from favorites.
  Future<void> removeFavorite(String id) async {
    try {
      await _service.removeFavorite(id);
      _message = "Favorite removed";
    } catch (e) {
      _message = "Failed to remove favorite: $e";
    } finally {
      notifyListeners();
    }
  }

  // Check if a restaurant is in favorites.
  Future<bool> isFavorite(String id) async {
    try {
      return await _service.isFavorite(id);
    } catch (_) {
      return false;
    }
  }
}
