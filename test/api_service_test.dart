import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late ApiService apiService;

  setUp(() {
    mockClient = MockHttpClient();
    apiService = ApiService(client: mockClient);

    registerFallbackValue(Uri());
  });

  group('getRestaurantList', () {
    test(
      'returns RestaurantListResponse when API call is successful',
      () async {
        final responseData = {
          'error': false,
          'message': 'success',
          'count': 2,
          'restaurants': [
            {
              'id': 'rqdv5juczeskfw1e867',
              'name': 'Melting Pot',
              'description': 'Lorem ipsum dolor sit amet',
              'pictureId': '14',
              'city': 'Medan',
              'rating': 4.2,
            },
            {
              'id': 's1knt6za9kkfw1e867',
              'name': 'Kafe Kita',
              'description': 'Quisque rutrum. Aenean imperdiet.',
              'pictureId': '25',
              'city': 'Gorontalo',
              'rating': 4.0,
            },
          ],
        };

        final uri = Uri.parse('https://restaurant-api.dicoding.dev/list');
        when(() => mockClient.get(uri)).thenAnswer(
          (_) async => http.Response(json.encode(responseData), 200),
        );

        final result = await apiService.getRestaurantList();

        expect(result, isA<RestaurantListResponse>());
        expect(result.error, false);
        expect(result.message, 'success');
        expect(result.count, 2);
        expect(result.restaurants.length, 2);
        expect(result.restaurants[0].name, 'Melting Pot');
        expect(result.restaurants[1].name, 'Kafe Kita');

        verify(() => mockClient.get(uri)).called(1);
      },
    );

    test('throws Exception when API call fails', () async {
      final uri = Uri.parse('https://restaurant-api.dicoding.dev/list');
      when(
        () => mockClient.get(uri),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => apiService.getRestaurantList(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            'Exception: Failed to load restaurant list',
          ),
        ),
      );

      verify(() => mockClient.get(uri)).called(1);
    });

    test('throws Exception when timeout occurs', () async {
      final uri = Uri.parse('https://restaurant-api.dicoding.dev/list');
      when(() => mockClient.get(uri)).thenAnswer(
        (_) async => throw http.ClientException('Connection timeout'),
      );

      expect(() => apiService.getRestaurantList(), throwsA(isA<Exception>()));
    });
  });
}
