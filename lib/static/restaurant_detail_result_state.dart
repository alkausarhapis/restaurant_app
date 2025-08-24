import 'package:restaurant_app/data/model/restaurant.dart';

sealed class RestaurantDetailResultState {}

class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailResultLoading extends RestaurantDetailResultState {}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String error;
  RestaurantDetailErrorState(this.error);
}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final Restaurant data;
  RestaurantDetailLoadedState(this.data);
}
