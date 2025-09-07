import 'package:restaurant_app/data/model/restaurant.dart';

class FavoriteRestaurant {
  final String id;
  final String name;
  final String city;
  final String pictureId;
  final double rating;
  final String description;

  const FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.pictureId,
    required this.rating,
    required this.description,
  });

  factory FavoriteRestaurant.fromMap(Map<String, dynamic> map) {
    return FavoriteRestaurant(
      id: map['id'] as String,
      name: map['name'] as String,
      city: (map['city'] as String?) ?? '',
      pictureId: (map['pictureId'] as String?) ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String,
    );
  }
}

// Extension for convert FavoriteRestaurant object to Restaurant (restaurant list) object.
extension FavoriteToRestaurant on FavoriteRestaurant {
  Restaurant toRestaurant() => Restaurant(
    id: id,
    name: name,
    city: city,
    pictureId: pictureId,
    rating: rating,
    description: description,
  );
}
