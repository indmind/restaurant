import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/db.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/providers/providers.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteRestaurantRepository {
  Database _db;

  FavoriteRestaurantRepository(this._db);

  Future<List<Restaurant>> getAll() async {
    List<Map<String, dynamic>> results =
        await _db.query(kFavoriteRestaurantsTable);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<void> add(Restaurant restaurant) async {
    await _db.insert(kFavoriteRestaurantsTable, restaurant.toRecord());
  }

  Future<void> remove(Restaurant restaurant) async {
    await _db.delete(
      kFavoriteRestaurantsTable,
      where: 'id = ?',
      whereArgs: [
        restaurant.id,
      ],
    );
  }
}

final favoriteRestaurantRepositoryProvider =
    Provider<FavoriteRestaurantRepository>((ref) {
  return FavoriteRestaurantRepository(
    ref.read(
      dbProvider,
    ),
  );
});
