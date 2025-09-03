import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _onQueryChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<RestaurantSearchProvider>().searchRestaurants(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Hero(
                tag: 'search-bar',
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    onChanged: _onQueryChanged,
                    onSubmitted: (v) => context
                        .read<RestaurantSearchProvider>()
                        .searchRestaurants(v),
                    decoration: const InputDecoration(
                      hintText: 'Cari restoran...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Consumer<RestaurantSearchProvider>(
                  builder: (context, value, _) {
                    final state = value.state;

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.isSuccess) {
                      final restaurants = state.data!;
                      if (restaurants.isEmpty) {
                        return const Center(
                          child: Text('Restoran tidak ditemukan'),
                        );
                      }
                      return ListView.builder(
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
                                    .read<RestaurantSearchProvider>()
                                    .searchRestaurants(_controller.text);
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Coba Lagi"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.isError) {
                      return Center(
                        child: Text(state.message ?? 'Terjadi kesalahan'),
                      );
                    }

                    return const Center(
                      child: Text('Mulai cari restoran favoritmu!'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
