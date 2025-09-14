import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/local/sqflite_service.dart';
import 'package:restaurant_app/provider/db/local_database_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/index_nav_provider.dart';
import 'package:restaurant_app/provider/notification/local_notifications_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/provider/prefs/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/detail/review/add_review_screen.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/main_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/screen/setting/settings_screen.dart';
import 'package:restaurant_app/service/local_notifications_service.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final launchDetails = await flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails();

  String initialRoute = NavigationRoute.mainRoute.name;
  String? initialPayload;

  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final payload = launchDetails!.notificationResponse?.payload;

    if (payload != null && payload.isNotEmpty) {
      if (payload == 'random') {
        initialRoute = NavigationRoute.mainRoute.name;
      } else {
        initialRoute = NavigationRoute.detailRoute.name;
        initialPayload = payload;
      }
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final preferencesService = SharedPreferencesService(prefs);
  final initialSetting = preferencesService.getSettingValue();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => preferencesService),
        Provider(create: (_) => SqfliteService()),

        ChangeNotifierProvider(
          create: (_) => PayloadProvider(payload: initialPayload),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocalNotificationProvider(
            LocalNotificationsService(),
            ctx.read<SharedPreferencesService>(),
            ctx.read<ApiService>(),
          )..init(),
        ),

        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<SqfliteService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            initialMode: initialSetting.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        ),
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
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
      ],
      child: MainApp(initialRoute: initialRoute),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  StreamSubscription<String?>? _notificationSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationSubscription = selectNotificationStream.stream.listen((
        String? payload,
      ) async {
        if (!mounted) return;
        final payloadProvider = context.read<PayloadProvider>();

        payloadProvider.payload = payload;

        if (payload == null || !mounted) return;

        navigatorKey.currentState?.pushNamed(
          NavigationRoute.detailRoute.name,
          arguments: payload,
        );
      });
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Restaurants',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: widget.initialRoute,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.homeRoute.name: (context) => const HomeScreen(),
            NavigationRoute.settingRoute.name: (context) =>
                const SettingsScreen(),
            NavigationRoute.favoriteRoute.name: (context) =>
                const FavoriteScreen(),
            NavigationRoute.detailRoute.name: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              if (args == null) {
                return const MainScreen();
              }
              return DetailScreen(restaurantId: args as String);
            },
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
            NavigationRoute.addReviewRoute.name: (context) =>
                const AddReviewScreen(),
          },
        );
      },
    );
  }
}
