import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/provider/db/local_database_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocalDatabaseProvider>().loadAllFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Restoran Favorit',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<LocalDatabaseProvider>(
                  builder: (context, value, _) {
                    final favorites = value.favoriteRestaurants;

                    if (favorites == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (favorites.isEmpty) {
                      return const Center(child: Text('No Favorites'));
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final restaurant = favorites[index].toRestaurant();
                        return RestaurantCardWidget(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NavigationRoute.detailRoute.name,
                              arguments: restaurant.id,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
