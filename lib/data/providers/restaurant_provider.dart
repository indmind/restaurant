import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/repositories/repositories.dart';

class RestaurantNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  Reader _read;

  RestaurantNotifier(this._read) : super(AsyncValue.loading()) {
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      state = AsyncValue.data(
          await _read(restaurantRepositoryProvider).getAllRestaurants());
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, AsyncValue<List<Restaurant>>>(
  (ref) {
    return RestaurantNotifier(ref.read);
  },
);

final filteredRestaurantProvider = Provider<List<Restaurant>>((ref) {
  final restaurantRef = ref.watch(restaurantProvider);
  final query = ref.watch(restaurantSearchProvider).state;

  return restaurantRef.maybeWhen(
    data: (restaurants) => query == null || query == ''
        ? restaurants
        : restaurants
            .where((restaurant) =>
                restaurant.name!.toLowerCase().contains(query) ||
                restaurant.description!.toLowerCase().contains(query) ||
                restaurant.city!.toLowerCase().contains(query))
            .toList(),
    orElse: () => [],
  );
});

final restaurantSearchProvider = StateProvider<String?>((_) => null);
final selectedRestaurantProvider = StateProvider<Restaurant?>((_) => null);
