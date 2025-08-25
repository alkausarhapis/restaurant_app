import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      restaurant: RestaurantDetail.fromJson(
        json['restaurant'] as Map<String, dynamic>,
      ),
    );
  }
}
