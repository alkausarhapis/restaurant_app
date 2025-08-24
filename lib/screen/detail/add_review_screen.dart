import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/detail/restaurant_review_provider.dart';
import 'package:restaurant_app/screen/detail/add_review_body.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final restaurantId = args['restaurantId'] ?? '';
    final restaurantName = args['restaurantName'] ?? '';

    return ChangeNotifierProvider(
      create: (context) => RestaurantReviewProvider(context.read<ApiService>()),
      child: AddReviewBody(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
      ),
    );
  }
}
