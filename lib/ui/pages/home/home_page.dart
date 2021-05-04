import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/providers.dart';

import 'widgets/restaurant_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          final restaurants = watch(restaurantProvider);

          return restaurants.when(
            data: (restaurants) => RestaurantList(restaurants: restaurants),
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          );
        },
      ),
    );
  }
}
