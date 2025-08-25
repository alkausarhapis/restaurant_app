import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';

sealed class RestaurantDetailResultState {}

class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailResultLoading extends RestaurantDetailResultState {}

class RestaurantDetailNoInternetState extends RestaurantDetailResultState {}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String error;
  RestaurantDetailErrorState(this.error);
}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final RestaurantDetail data;
  RestaurantDetailLoadedState(this.data);
}
