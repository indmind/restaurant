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
        await _read(restaurantRepositoryProvider).getAllRestaurants(),
      );
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchRestaurants(String query) async {
    state = AsyncValue.loading();

    if (query == '') loadRestaurants();

    try {
      state = AsyncValue.data(
        await _read(restaurantRepositoryProvider).searchRestaurant(query),
      );
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
