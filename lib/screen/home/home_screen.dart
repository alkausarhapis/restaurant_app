import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: AppColor.orange.color),
        ),
      ),
    );
  }
}
