import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/provider/db/local_database_provider.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';

class FavoriteIcbuttonWidget extends StatefulWidget {
  final RestaurantDetail restaurant;

  const FavoriteIcbuttonWidget({super.key, required this.restaurant});

  @override
  State<FavoriteIcbuttonWidget> createState() => _FavoriteIcbuttonWidgetState();
}

class _FavoriteIcbuttonWidgetState extends State<FavoriteIcbuttonWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dbProvider = context.read<LocalDatabaseProvider>();
      final iconProvider = context.read<FavoriteIconProvider>();

      final isFav = await dbProvider.isFavorite(widget.restaurant.id);
      iconProvider.isFavorited = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFavorited = context.watch<FavoriteIconProvider>().isFavorited;

    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
      onPressed: () async {
        final dbProvider = context.read<LocalDatabaseProvider>();
        final iconProvider = context.read<FavoriteIconProvider>();

        try {
          if (!isFavorited) {
            await dbProvider.addToFavorite(widget.restaurant);
            if (!mounted) return;
            _showSnackBar('${widget.restaurant.name} added to favorites');
          } else {
            await dbProvider.removeFavorite(widget.restaurant.id);
            if (!mounted) return;
            _showSnackBar(
              '${widget.restaurant.name} removed from favorites',
              isError: true,
            );
          }

          iconProvider.isFavorited = !isFavorited;
          await dbProvider.loadAllFavorites();
        } catch (e) {
          if (!mounted) return;
          _showSnackBar('Failed: $e', isError: true);
        }
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: isError
              ? TextStyle(color: Theme.of(context).colorScheme.errorContainer)
              : null,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
