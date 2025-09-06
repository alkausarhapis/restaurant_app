import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/favorite_icbutton_widget.dart';
import 'package:restaurant_app/screen/detail/section_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  final RestaurantDetail restaurant;
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
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChangeNotifierProvider(
                create: (_) => FavoriteIconProvider(),
                child: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: FavoriteIcbuttonWidget(restaurant: restaurant),
                ),
              ),
            ),
          ],
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city_rounded, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.city,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    restaurant.rating < 2
                        ? Icons.star_outline
                        : restaurant.rating < 4
                        ? Icons.star_half
                        : Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${restaurant.rating}',
                    style: Theme.of(context).textTheme.bodyMedium,
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

        SliverList(
          delegate: SliverChildListDelegate([
            if (restaurant.address.isNotEmpty) ...[
              SectionCardWidget(
                title: 'Alamat',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.place, size: 18, color: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('${restaurant.address}, ${restaurant.city}'),
                    ),
                  ],
                ),
              ),
            ],

            if (restaurant.categories.isNotEmpty) ...[
              SectionCardWidget(
                title: 'Kategori',
                child: Wrap(
                  spacing: 8,
                  children: restaurant.categories
                      .map(
                        (c) => Chip(
                          side: BorderSide(color: AppColor.orange.color),
                          label: Text(c.name),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],

            SectionCardWidget(
              title: 'Menu',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (restaurant.menu.foods.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Makanan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: restaurant.menu.foods
                          .map(
                            (m) => Chip(
                              label: Text(m.name),
                              side: BorderSide.none,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (restaurant.menu.drinks.isNotEmpty) ...[
                    Text(
                      'Minuman',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: restaurant.menu.drinks
                          .map(
                            (m) => Chip(
                              label: Text(m.name),
                              side: BorderSide.none,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            SectionCardWidget(
              title: 'Ulasan Pelanggan',
              child: restaurant.customerReviews.isEmpty
                  ? const Text('Belum ada ulasan.')
                  : Column(
                      children: restaurant.customerReviews
                          .map(
                            (r) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColor.orange.color
                                    .withValues(alpha: 0.2),
                                child: Text(
                                  r.name.isNotEmpty
                                      ? r.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: AppColor.orange.color,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(r.name),
                                  const SizedBox(width: 8),
                                  Text(
                                    r.date,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outline,
                                        ),
                                  ),
                                ],
                              ),
                              subtitle: Text(r.review),
                            ),
                          )
                          .toList(),
                    ),
            ),

            const SizedBox(height: 8),
          ]),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final posted = await Navigator.pushNamed(
                    context,
                    NavigationRoute.addReviewRoute.name,
                    arguments: {
                      'restaurantId': restaurant.id,
                      'restaurantName': restaurant.name,
                    },
                  );

                  if (posted == true) {
                    if (context.mounted) {
                      Provider.of<RestaurantDetailProvider>(
                        context,
                        listen: false,
                      ).fetchRestaurantDetail(restaurant.id);
                    }
                  }
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
          ),
        ),
      ],
    );
  }
}
