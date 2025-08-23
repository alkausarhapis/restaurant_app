import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class DetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  const DetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
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
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
            ]),
          ),
        ],
      ),
    );
  }
}
