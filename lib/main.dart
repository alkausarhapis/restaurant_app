import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/screen/detail/review/add_review_screen.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantSearchProvider(context.read<ApiService>()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurants',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String,
            ),
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
            NavigationRoute.addReviewRoute.name: (context) =>
                const AddReviewScreen(),
          },
        );
      },
    );
  }
}
