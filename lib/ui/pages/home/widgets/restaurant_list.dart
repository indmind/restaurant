
import 'package:flutter/material.dart';
import 'package:restaurant/data/model/models.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: restaurants.length,
      separatorBuilder: (_, __) => SizedBox(height: 14),
      itemBuilder: (_, index) => Text(restaurants[index].name ?? '-'),
    );
  }
}
