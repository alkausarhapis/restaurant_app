import 'package:restaurant_app/data/model/review/customer_review.dart';

sealed class ReviewSubmitState {}

class ReviewIdleState extends ReviewSubmitState {}

class ReviewSubmittingState extends ReviewSubmitState {}

class ReviewSubmitSuccessState extends ReviewSubmitState {
  final List<CustomerReview> customerReviews;
  ReviewSubmitSuccessState(this.customerReviews);
}

class ReviewSubmitErrorState extends ReviewSubmitState {
  final String message;
  ReviewSubmitErrorState(this.message);
}
