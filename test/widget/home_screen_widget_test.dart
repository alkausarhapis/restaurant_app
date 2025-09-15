import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/static/global_result_state.dart';

class MockRestaurantListProvider extends Mock
    implements RestaurantListProvider {}

void main() {
  late MockRestaurantListProvider restaurantListProvider;
  late Widget testWidget;

  setUp(() {
    restaurantListProvider = MockRestaurantListProvider();

    testWidget = MaterialApp(
      home: ChangeNotifierProvider<RestaurantListProvider>.value(
        value: restaurantListProvider,
        child: const HomeScreen(),
      ),
    );

    when(
      () => restaurantListProvider.fetchRestaurantList(),
    ).thenAnswer((_) async {});
  });

  group('HomeScreen Widget Test', () {
    testWidgets('should display error message when error occurs', (
      WidgetTester tester,
    ) async {
      final errorMessage = 'Failed to load restaurants';
      when(
        () => restaurantListProvider.resultState,
      ).thenReturn(ResultState.error(errorMessage));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
