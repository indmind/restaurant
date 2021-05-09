import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/common/urls.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:http/http.dart' as http;

class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/list'),
      );

      if (response.body == '') return [];

      final List json = jsonDecode(response.body)["restaurants"];

      return json.map((j) => Restaurant.fromJson(j)).toList();
    } on Exception catch (_) {
      throw CustomException(message: 'Gagal untuk memuat restoran');
    }
  }

  Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/search?q=$query'),
      );

      if (response.body == '') return [];

      final List json = jsonDecode(response.body)["restaurants"];

      return json.map((j) => Restaurant.fromJson(j)).toList();
    } on Exception catch (_) {
      throw CustomException(message: 'Gagal untuk memuat restoran');
    }
  }

  Future<Restaurant?> getRestaurant(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/detail/$id'),
      );

      if (response.body == '') return null;

      final Map<String, dynamic> json = jsonDecode(response.body)["restaurant"];

      return Restaurant.fromJson(json);
    } on Exception catch (_) {
      throw CustomException(message: 'Gagal untuk memuat restoran');
    }
  }

  Future<void> postReview(
      String restaurantId, String name, String review) async {
    try {
      Map<String, String> headers = {
        "X-Auth-Token": "12345",
      };

      Map<String, dynamic> data = {
        "id": restaurantId,
        "name": name,
        "review": review,
      };

      await http.post(
        Uri.parse('$kBaseUrl/review'),
        headers: headers,
        body: data,
      );
    } on Exception catch (_) {
      throw CustomException(message: 'Gagal untuk memuat restoran');
    }
  }
}

final restaurantRepositoryProvider =
    Provider<RestaurantRepository>((_) => RestaurantRepository());
