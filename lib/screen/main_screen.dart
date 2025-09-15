import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/index_nav_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/setting/settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color inactiveColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: context.watch<IndexNavProvider>().idxBottomNavbar,
          onTap: (index) {
            context.read<IndexNavProvider>().setIdxBottomNavbar = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 0
                      ? Colors.deepOrangeAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.home,
                  size: 24,
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 0
                      ? Colors.white
                      : inactiveColor,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 1
                      ? Colors.deepOrangeAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.favorite,
                  size: 24,
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 1
                      ? Colors.white
                      : inactiveColor,
                ),
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 2
                      ? Colors.deepOrangeAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.settings,
                  size: 24,
                  color: context.watch<IndexNavProvider>().idxBottomNavbar == 2
                      ? Colors.white
                      : inactiveColor,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.idxBottomNavbar) {
            0 => const HomeScreen(),
            1 => const FavoriteScreen(),
            _ => const SettingsScreen(),
          };
        },
      ),
    );
  }
}
