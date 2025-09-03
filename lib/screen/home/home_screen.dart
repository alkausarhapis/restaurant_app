import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<RestaurantListProvider>().fetchRestaurantList();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Restaurant App",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColor.orange.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Aplikasi ini membantu Anda menemukan restoran terbaik di Indonesia.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'search-bar',
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final searchProvider = context
                                .read<RestaurantSearchProvider>();
                            await Navigator.pushNamed(context, '/search');
                            searchProvider.reset();
                          },
                          icon: const Icon(Icons.search, size: 24),
                          label: const Text(
                            "Cari Restoran",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppColor.orange.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<RestaurantListProvider>(
                    builder: (context, value, _) {
                      final state = value.resultState;

                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.isSuccess) {
                        final restaurants = state.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = restaurants[index];
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
                      }

                      if (state.isNoInternet) {
                        return Column(
                          children: [
                            Image.asset('assets/no-internet.png', height: 150),
                            const SizedBox(height: 16),
                            const Text('Tidak ada koneksi internet'),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context
                                  .read<RestaurantListProvider>()
                                  .fetchRestaurantList(),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Coba Lagi"),
                            ),
                          ],
                        );
                      }

                      if (state.isError) {
                        return Center(
                          child: Text(state.message ?? 'Terjadi kesalahan'),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
