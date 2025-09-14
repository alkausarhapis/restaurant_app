import 'dart:async';
import 'dart:math'; // untuk random saat payload == 'random'

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
// notification stuff
import 'package:restaurant_app/service/local_notifications_service.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint("Background tap handler: ${notificationResponse.payload}");
  selectNotificationStream.add(notificationResponse.payload);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the background handler
  FlutterLocalNotificationsPlugin().initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // cek apakah app diluncurkan dari notifikasi (cold start)
  final launchDetails = await flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails();
  print("Launch details: $launchDetails"); // Add this
  print(
    "Launch payload: ${launchDetails?.notificationResponse?.payload}",
  ); // Add this

  String initialRoute = NavigationRoute.mainRoute.name;
  String? initialPayload;

  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final payload = launchDetails!.notificationResponse?.payload;
    print("Cold start payload: $payload");

    if (payload != null && payload.isNotEmpty) {
      if (payload == 'random') {
        // Handle random case - maybe set a flag to fetch random on start
        initialRoute = NavigationRoute.mainRoute.name;
      } else {
        initialRoute = NavigationRoute.detailRoute.name;
        initialPayload = payload;
      }
    } else {
      // Default if payload is null/empty
      initialRoute = NavigationRoute.mainRoute.name;
    }
  }

  final prefs = await SharedPreferences.getInstance();
  final spService = SharedPreferencesService(prefs);
  final initialSetting = spService.getSettingValue();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => spService),
        Provider(create: (_) => SqfliteService()),

        // ===== Notifications
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

        // ===== Existing providers
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
  StreamSubscription<String?>? _sub;

  @override
  void initState() {
    super.initState();
    // listen payload dari stream → update provider & navigate (tanpa rootNavKey)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sub = selectNotificationStream.stream.listen((String? payload) async {
        print("Stream received payload: $payload");
        context.read<PayloadProvider>().payload = payload;

        if (payload == null) return;

        if (payload == 'random') {
          try {
            // Fetch random restaurant
            final api = context.read<ApiService>();
            final listResp = await api.getRestaurantList();
            final list = listResp.restaurants;
            if (list.isEmpty) return;

            final r = list[Random().nextInt(list.length)];

            // Use navigatorKey instead of context
            navigatorKey.currentState?.pushNamed(
              NavigationRoute.detailRoute.name,
              arguments: r.id,
            );
          } catch (e) {
            print("Error navigating to random restaurant: $e");
          }
        } else if (payload.isNotEmpty) {
          // Use navigatorKey for direct navigation too
          navigatorKey.currentState?.pushNamed(
            NavigationRoute.detailRoute.name,
            arguments: payload,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey, // Add this line
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
                // Handle null payload - either return to home or show error
                return const HomeScreen(); // or some error screen
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
