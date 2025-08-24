import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/static/review_submit_state.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService _apiService;
  RestaurantReviewProvider(this._apiService);

  ReviewSubmitState resultState = ReviewIdleState();

  Future<void> submitReview({
    required String restaurantId,
    required String reviewerName,
    required String reviewText,
  }) async {
    final name = reviewerName.trim();
    final review = reviewText.trim();

    if (name.isEmpty || review.isEmpty) {
      resultState = ReviewSubmitErrorState('Nama dan ulasan wajib diisi');
      notifyListeners();
      return;
    }

    resultState = ReviewSubmittingState();
    notifyListeners();

    try {
      final res = await _apiService.addReview(
        id: restaurantId,
        name: name,
        review: review,
      );
      if (res.error) {
        resultState = ReviewSubmitErrorState(res.message);
      } else {
        resultState = ReviewSubmitSuccessState(res.customerReviews);
      }
    } on SocketException {
      resultState = ReviewSubmitErrorState('Tidak ada koneksi internet');
    } on TimeoutException {
      resultState = ReviewSubmitErrorState('Koneksi lambat. Coba lagi');
    } catch (e) {
      resultState = ReviewSubmitErrorState(e.toString());
    }
    notifyListeners();
  }

  void reset() {
    resultState = ReviewIdleState();
    notifyListeners();
  }
}
