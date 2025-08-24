import 'package:restaurant_app/data/model/customer_review.dart';

class RestaurantReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  RestaurantReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantReviewResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantReviewResponse(
      error: json['error'],
      message: json['message'],
      customerReviews: json['customerReviews'] != null
          ? List<CustomerReview>.from(
              json['customerReviews'].map((x) => CustomerReview.fromJson(x)),
            )
          : <CustomerReview>[],
    );
  }
}
