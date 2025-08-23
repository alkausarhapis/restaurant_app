import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/theme/app_theme.dart';

// TODO: provider & api services

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
          /// [ModalRoute] is used to retrieve the arguments passed to the route
          restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
        ),
        NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
      },
    );
  }
}
