class CategoryRestaurant {
  final String name;

  CategoryRestaurant({required this.name});

  factory CategoryRestaurant.fromJson(Map<String, dynamic> json) {
    return CategoryRestaurant(name: json['name']);
  }
}
