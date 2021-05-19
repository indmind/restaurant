import 'package:flutter/material.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/favorite_restaurants_provider.dart';

import 'restaurant_list_item.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    Key? key,
    required this.restaurants,
    this.dismissable = false,
  }) : super(key: key);

  final List<Restaurant> restaurants;
  final bool dismissable;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (_, index) {
        final restaurant = restaurants[index];

        if (!dismissable)
          return RestaurantListItem(
            restaurant: restaurant,
          );

        return Dismissible(
          onDismissed: (direction) {
            context
                .read(favoriteRestaurantProvider.notifier)
                .remove(restaurant);
          },
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          key: Key(restaurant.id ?? ''),
          child: RestaurantListItem(
            restaurant: restaurant,
          ),
        );
      },
    );
  }
}
