import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/repositories/repositories.dart';
import 'package:restaurant/data/providers/restaurant_provider.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  group('Restaurant Provider', () {
    late MockRestaurantRepository _mockRepo;
    late ProviderContainer container;

    setUp(() {
      _mockRepo = MockRestaurantRepository();

      container = ProviderContainer(
        overrides: [
          restaurantRepositoryProvider.overrideWithProvider(
            Provider(
              (_) => _mockRepo,
            ),
          ),
        ],
      );
    });

    test('should load data from repository when instance is created', () async {
      final _restaurant = Restaurant(name: 'Kuntilanak');

      when(_mockRepo.getAllRestaurants()).thenAnswer(
        (realInvocation) => Future.value([_restaurant]),
      );

      expect(
        container.read(restaurantProvider),
        AsyncValue<List<Restaurant>>.loading(),
      );

      await Future<void>.value();

      expect(
        container.read(restaurantProvider).data?.value,
        [
          isA<Restaurant>()
              .having((r) => r.name, 'Restaurant Name', 'Kuntilanak'),
        ],
      );
    });

    group('search', () {
      final _fakeRestaurants = [
        Restaurant(name: 'Bakso Malang'),
        Restaurant(name: 'Sop Buntut'),
        Restaurant(name: 'Ketan Hijau'),
      ];

      setUp(() {
        when(_mockRepo.getAllRestaurants()).thenAnswer(
          (realInvocation) => Future.value(_fakeRestaurants),
        );
      });

      test('should returns all restaurants when provided with empty string',
          () async {
        await container.read(restaurantProvider.notifier).searchRestaurants('');

        expect(
          container.read(restaurantProvider).data?.value,
          _fakeRestaurants,
        );
      });

      test(
          'should returns searched restaurants when provided with a valid query',
          () async {
        when(_mockRepo.searchRestaurant('sop')).thenAnswer(
          (realInvocation) => Future.value([_fakeRestaurants[1]]),
        );

        await container
            .read(restaurantProvider.notifier)
            .searchRestaurants('sop');

        expect(
          container.read(restaurantProvider).data?.value,
          [
            isA<Restaurant>()
                .having((r) => r.name, 'Restaurant Name', 'Sop Buntut'),
          ],
        );
      });

      test('should returns empty list when provided with an invalid query',
          () async {
        when(_mockRepo.searchRestaurant('dicoding')).thenAnswer(
          (realInvocation) => Future.value([]),
        );

        await container
            .read(restaurantProvider.notifier)
            .searchRestaurants('dicoding');

        expect(
          container.read(restaurantProvider).data?.value,
          isEmpty,
        );
      });

      test('should handle error properly when something unexpected happened',
          () async {
        when(_mockRepo.searchRestaurant('error')).thenThrow(
          CustomException(message: 'TIBA-TIBA ERROR'),
        );

        // buat make sure intial load
        await container.read(restaurantProvider.notifier).loadRestaurants();

        await container
            .read(restaurantProvider.notifier)
            .searchRestaurants('error');

        final _customExceptionMatcher = isA<AsyncError<List<Restaurant>>>()
            .having(
              (error) => error.error,
              'Error type',
              isA<CustomException>(),
            )
            .having(
              (error) => (error.error as CustomException).message,
              'Error message',
              'TIBA-TIBA ERROR',
            );

        expect(
          container.read(restaurantProvider),
          _customExceptionMatcher,
        );
      });
    });

    test('should be able to handle error', () async {
      when(_mockRepo.getAllRestaurants()).thenThrow(
        CustomException(message: 'INDIHOME LAGI DOWN MAS'),
      );

      container.read(restaurantProvider);

      await Future<void>.value();

      final _customExceptionMatcher = isA<AsyncError<List<Restaurant>>>()
          .having(
            (error) => error.error,
            'Error type',
            isA<CustomException>(),
          )
          .having(
            (error) => (error.error as CustomException).message,
            'Error message',
            'INDIHOME LAGI DOWN MAS',
          );

      expect(
        container.read(restaurantProvider),
        _customExceptionMatcher,
      );
    });
  });
}
