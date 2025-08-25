import 'package:restaurant_app/data/model/menu_item.dart';

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: json['foods'] != null
          ? List<MenuItem>.from(
              (json['foods'] as List).map(
                (x) => MenuItem.fromJson(x as Map<String, dynamic>),
              ),
            )
          : <MenuItem>[],
      drinks: json['drinks'] != null
          ? List<MenuItem>.from(
              (json['drinks'] as List).map(
                (x) => MenuItem.fromJson(x as Map<String, dynamic>),
              ),
            )
          : <MenuItem>[],
    );
  }
}
