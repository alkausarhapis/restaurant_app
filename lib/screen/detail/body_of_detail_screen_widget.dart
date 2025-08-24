import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  final Restaurant restaurant;
  const BodyOfDetailScreenWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: restaurant.pictureId,
              child: Image.network(
                "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),

        // --- Konten pakai SliverList ---
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                restaurant.name,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColor.orange.color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Chip(
                    avatar: const Icon(Icons.location_on, color: Colors.red),
                    label: Text(restaurant.city),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: Icon(
                      restaurant.rating < 2
                          ? Icons.star_outline
                          : restaurant.rating < 4
                          ? Icons.star_half
                          : Icons.star,
                      color: Colors.amber,
                    ),
                    label: Text('${restaurant.rating}'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                restaurant.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.addReviewRoute.name,
                    arguments: {
                      'restaurantId': restaurant.id,
                      'restaurantName': restaurant.name,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColor.orange.color,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Beri Review',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
