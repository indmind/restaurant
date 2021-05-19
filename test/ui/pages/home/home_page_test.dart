import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/data/repositories/repositories.dart';
import 'package:restaurant/ui/pages/home/home_page.dart';
import 'package:restaurant/ui/pages/home/widgets/app_bar.dart';
import 'package:restaurant/ui/pages/home/widgets/restaurant_list.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  group('Home Page', () {
    final _mockRepo = MockRestaurantRepository();
    final _fakeRestaurants = [
      Restaurant(name: 'Bakso Malang'),
      Restaurant(name: 'Sop Buntut'),
      Restaurant(name: 'Ketan Hijau'),
    ];

    Widget createHomeScreen() => ProviderScope(
          overrides: [
            restaurantRepositoryProvider.overrideWithProvider(
              Provider(
                (_) => _mockRepo,
              ),
            ),
          ],
          child: MaterialApp(
            home: HomePage(),
          ),
        );

    setUp(() {
      when(_mockRepo.getAllRestaurants()).thenAnswer(
        (realInvocation) => Future.value(_fakeRestaurants),
      );

      when(_mockRepo.searchRestaurant('melting')).thenAnswer(
        (realInvocation) => Future.value([]),
      );
    });

    testWidgets('should have header and content', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(SliverPersistentHeader), findsOneWidget);
      expect(find.byType(SliverToBoxAdapter), findsOneWidget);
    });

    testWidgets('should have correct header content', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.text('Laper?'), findsOneWidget);
      expect(find.text('Rekomendasi restoran untuk kamu!'), findsOneWidget);
      expect(find.text('Rekomendasi restoran untuk kamu!'), findsOneWidget);

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'Cari',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should search for movies', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      final searchButton = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Cari',
      );

      await tester.enterText(searchButton, 'melting');

      // wait for animation and debounce
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byType(RestaurantList), findsNothing);
      expect(find.text('Restoran tidak ditemukan...'), findsOneWidget);
    });
  });
}