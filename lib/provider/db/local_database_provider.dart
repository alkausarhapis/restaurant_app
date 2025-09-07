// lib/provider/db/local_database_provider.dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/local/sqflite_service.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final SqfliteService _service;
  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<FavoriteRestaurant>? _favoriteRestaurants;
  List<FavoriteRestaurant>? get favoriteRestaurants => _favoriteRestaurants;

  // Insert/update favorite using stored data at RestaurantDetail.
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

  Future<void> loadAllFavorites() async {
    try {
      _favoriteRestaurants = await _service.getAllFavorites();
      _message = "Favorites loaded";
    } catch (e) {
      _message = "Failed to load favorites: $e";
    } finally {
      notifyListeners();
    }
  }

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

  Future<bool> isFavorite(String id) async {
    try {
      return await _service.isFavorite(id);
    } catch (_) {
      return false;
    }
  }
}
