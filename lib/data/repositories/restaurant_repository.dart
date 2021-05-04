import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';

class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final data =
          await rootBundle.loadString('assets/json/local_restaurant.json');

      if (data == '') return [];

      final List json = jsonDecode(data)["restaurants"];

      return json.map((j) => Restaurant.fromJson(j)).toList();
    } on Exception catch (_) {
      throw CustomException(message: 'Failed to load restaurants');
    }
  }
}

final restaurantRepositoryProvider =
    Provider<RestaurantRepository>((_) => RestaurantRepository());
