import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/local/sqflite_service.dart';
import 'package:restaurant_app/data/model/detail/menu.dart';
import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:restaurant_app/provider/db/local_database_provider.dart';

class MockSqfliteService extends Mock implements SqfliteService {}

void main() {
  late LocalDatabaseProvider provider;
  late MockSqfliteService mockService;

  setUp(() {
    mockService = MockSqfliteService();
    provider = LocalDatabaseProvider(mockService);
  });

  group('LocalDatabaseProvider', () {
    test('initial state should be correctly defined', () {
      expect(provider.message, "");

      expect(provider.favoriteRestaurants, null);
    });

    test(
      'loadAllFavorites should update state with favorites from database',
      () async {
        final mockFavorites = [
          FavoriteRestaurant(
            id: 'id1',
            name: 'Restaurant 1',
            description: 'Description 1',
            pictureId: 'pic1',
            city: 'City 1',
            rating: 4.5,
          ),
          FavoriteRestaurant(
            id: 'id2',
            name: 'Restaurant 2',
            description: 'Description 2',
            pictureId: 'pic2',
            city: 'City 2',
            rating: 4.0,
          ),
        ];

        when(
          () => mockService.getAllFavorites(),
        ).thenAnswer((_) async => mockFavorites);

        await provider.loadAllFavorites();

        expect(provider.message, "Favorites loaded");
        expect(provider.favoriteRestaurants, mockFavorites);
        expect(provider.favoriteRestaurants?.length, 2);
        verify(() => mockService.getAllFavorites()).called(1);
      },
    );

    test(
      'addToFavorite should add restaurant to favorites successfully',
      () async {
        final mockRestaurant = RestaurantDetail(
          id: 'id1',
          name: 'Restaurant 1',
          description: 'Description 1',
          pictureId: 'pic1',
          city: 'City 1',
          address: 'Address 1',
          rating: 4.5,
          categories: [],
          menu: Menu(foods: [], drinks: []),
          customerReviews: [],
        );

        when(
          () => mockService.upsertFavorite(mockRestaurant),
        ).thenAnswer((_) async => true);

        await provider.addToFavorite(mockRestaurant);

        expect(provider.message, "Restaurant 1 added to favorites");
        verify(() => mockService.upsertFavorite(mockRestaurant)).called(1);
      },
    );

    test('addToFavorite should handle exceptions gracefully', () async {
      final mockRestaurant = RestaurantDetail(
        id: 'id1',
        name: 'Restaurant 1',
        description: 'Description 1',
        pictureId: 'pic1',
        city: 'City 1',
        address: 'Address 1',
        rating: 4.5,
        categories: [],
        menu: Menu(foods: [], drinks: []),
        customerReviews: [],
      );

      when(
        () => mockService.upsertFavorite(mockRestaurant),
      ).thenThrow(Exception('Database error'));

      await provider.addToFavorite(mockRestaurant);

      expect(provider.message, contains("Failed to add favorite"));
      verify(() => mockService.upsertFavorite(mockRestaurant)).called(1);
    });

    test('isFavorite should return false when exception occurs', () async {
      when(
        () => mockService.isFavorite('id1'),
      ).thenThrow(Exception('Database error'));

      final result = await provider.isFavorite('id1');

      expect(result, false);
      verify(() => mockService.isFavorite('id1')).called(1);
    });

    test(
      'removeFavorite should update state when favorite is removed',
      () async {
        when(
          () => mockService.removeFavorite('id1'),
        ).thenAnswer((_) async => 1);

        await provider.removeFavorite('id1');

        expect(provider.message, "Favorite removed");
        verify(() => mockService.removeFavorite('id1')).called(1);
      },
    );
  });
}
