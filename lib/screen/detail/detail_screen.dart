import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.state) {
            RestaurantDetailResultLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantDetailLoadedState(data: var restaurant) =>
              BodyOfDetailScreenWidget(restaurant: restaurant),
            RestaurantDetailErrorState(error: var message) => Center(
              child: Text(message),
            ),
            RestaurantDetailNoInternetState() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/no-internet.png', height: 150),
                  const SizedBox(height: 16),
                  const Text('Tidak ada koneksi internet'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<RestaurantDetailProvider>()
                          .fetchRestaurantDetail(widget.restaurantId);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Coba Lagi"),
                  ),
                ],
              ),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
