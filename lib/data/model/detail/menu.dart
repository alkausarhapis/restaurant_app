import 'package:restaurant_app/data/model/detail/menu_item.dart';

class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'foods': foods.map((f) => f.toJson()).toList(),
      'drinks': drinks.map((d) => d.toJson()).toList(),
    };
  }
}
