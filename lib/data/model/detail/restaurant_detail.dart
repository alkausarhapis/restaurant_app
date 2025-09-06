import 'package:restaurant_app/data/model/detail/category.dart';
import 'package:restaurant_app/data/model/detail/menu.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/review/customer_review.dart';

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<CategoryRestaurant> categories;
  final Menu menu;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menu,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryRestaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
      menu: Menu.fromJson(json['menus'] as Map<String, dynamic>? ?? const {}),
      customerReviews: (json['customerReviews'] as List? ?? [])
          .map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'rating': rating,
      'categories': categories.map((c) => c.toJson()).toList(),
      'menus': menu.toJson(),
      'customerReviews': customerReviews.map((r) => r.toJson()).toList(),
    };
  }
}

extension RestaurantDetailMapper on RestaurantDetail {
  Restaurant toRestaurant() {
    return Restaurant(
      id: id,
      name: name,
      city: city,
      pictureId: pictureId,
      rating: rating,
      description: description,
    );
  }
}
