import 'package:flutter/material.dart';
import 'package:restaurant/data/model/models.dart';

import 'restaurant_list_item.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (_, index) => RestaurantListItem(
        restaurant: restaurants[index],
      ),
    );
  }
}
