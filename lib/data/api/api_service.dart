import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:restaurant_app/data/model/review/restaurant_review_response.dart';

class ApiService {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const timeLimit = Duration(seconds: 10);

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await client
        .get(Uri.parse('${_baseUrl}list'))
        .timeout(timeLimit);

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await client
        .get(Uri.parse('$_baseUrl/detail/$id'))
        .timeout(timeLimit);
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    final response = await client
        .get(Uri.parse('$_baseUrl/search?q=$query'))
        .timeout(timeLimit);
    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<RestaurantReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await client
        .post(
          Uri.parse('$_baseUrl/review'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id': id, 'name': name, 'review': review}),
        )
        .timeout(timeLimit);
    if (response.statusCode == 201) {
      return RestaurantReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }
}
