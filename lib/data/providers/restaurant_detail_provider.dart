import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/data/repositories/repositories.dart';

final restaurantDetailFamily = StateNotifierProvider.family<
    RestaurantDetailNotifier, AsyncValue<Restaurant?>, String>((ref, id) {
  return RestaurantDetailNotifier(ref.read, id);
});

class RestaurantDetailNotifier extends StateNotifier<AsyncValue<Restaurant?>> {
  Reader _read;
  String _id;

  RestaurantDetailNotifier(this._read, this._id) : super(AsyncValue.loading()) {
    loadRestaurant();
  }

  Future<void> loadRestaurant() async {
    try {
      state = AsyncValue.data(
        await _read(restaurantRepositoryProvider).getRestaurant(_id),
      );
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> postReview(String name, String review) async {
    try {
      await _read(restaurantRepositoryProvider).postReview(_id, name, review);
      await loadRestaurant();
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
