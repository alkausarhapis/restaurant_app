import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen_widget.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, _) {
          final state = value.state;

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isSuccess) {
            final restaurant = state.data!;
            return BodyOfDetailScreenWidget(restaurant: restaurant);
          }

          if (state.isNoInternet) {
            return Center(
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
            );
          }

          if (state.isError) {
            return Center(child: Text(state.message ?? 'Terjadi kesalahan'));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
