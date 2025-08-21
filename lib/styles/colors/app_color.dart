import 'package:flutter/material.dart';

enum AppColor {
  orange("Orange", Color(0xFFEF7700));

  const AppColor(this.name, this.color);
  final String name;
  final Color color;
}
