import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class RestaurantCardWidget extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;

  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 120,
                  maxWidth: 120,
                  minHeight: 90,
                  minWidth: 90,
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox.square(dimension: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox.square(dimension: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        Expanded(
                          child: Text(
                            restaurant.city,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          restaurant.rating < 2
                              ? Icons.star_outline
                              : restaurant.rating < 4
                              ? Icons.star_half
                              : Icons.star,
                          color: Colors.amber,
                        ),
                        Expanded(child: Text("${restaurant.rating}")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
