class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name};
  }
}
