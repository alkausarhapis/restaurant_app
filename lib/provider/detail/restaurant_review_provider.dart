import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/review/customer_review.dart';
import 'package:restaurant_app/static/global_result_state.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService _apiService;
  RestaurantReviewProvider(this._apiService);

  ResultState<List<CustomerReview>> _state = ResultState.none();
  ResultState<List<CustomerReview>> get state => _state;

  Future<void> submitReview({
    required String restaurantId,
    required String reviewerName,
    required String reviewText,
  }) async {
    final name = reviewerName.trim();
    final review = reviewText.trim();

    if (name.isEmpty || review.isEmpty) {
      _state = ResultState.error('Nama dan ulasan wajib diisi');
      notifyListeners();
      return;
    }

    _state = ResultState.loading();
    notifyListeners();

    try {
      final res = await _apiService.addReview(
        id: restaurantId,
        name: name,
        review: review,
      );

      if (res.error) {
        _state = ResultState.error(res.message);
      } else {
        _state = ResultState.success(res.customerReviews);
      }
    } on SocketException {
      _state = ResultState.error('Tidak ada koneksi internet');
    } on TimeoutException {
      _state = ResultState.error('Koneksi lambat. Coba lagi');
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
