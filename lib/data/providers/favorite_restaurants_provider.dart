import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/repositories/favorite_restaurant_repository.dart';

class FavoriteRestaurantNotifier
    extends StateNotifier<AsyncValue<List<Restaurant>>> {
  Reader _read;

  FavoriteRestaurantNotifier(this._read) : super(AsyncValue.loading()) {
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      state = AsyncValue.data(
        await _read(favoriteRestaurantRepositoryProvider).getAll(),
      );
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Restaurant restaurant) async {
    try {
      _read(favoriteRestaurantRepositoryProvider).add(restaurant);

      await loadRestaurants();
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> remove(Restaurant restaurant) async {
    try {
      _read(favoriteRestaurantRepositoryProvider).remove(restaurant);

      await loadRestaurants();
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(Restaurant restaurant) async {
    try {
      if (isFavorite(restaurant)) {
        await remove(restaurant);
      } else {
        await add(restaurant);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool isFavorite(Restaurant restaurant) {
    final favoriteRestaurants = state.data?.value ?? [];

    return favoriteRestaurants
        .where((res) => res.id == restaurant.id)
        .isNotEmpty;
  }
}

final favoriteRestaurantProvider = StateNotifierProvider<
    FavoriteRestaurantNotifier, AsyncValue<List<Restaurant>>>(
  (ref) {
    return FavoriteRestaurantNotifier(ref.read);
  },
);
