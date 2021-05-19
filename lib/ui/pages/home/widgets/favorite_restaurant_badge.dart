import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/favorite_restaurants_provider.dart';

class FavoriteRestaurantBadge extends HookWidget {
  const FavoriteRestaurantBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurants =
        useProvider(favoriteRestaurantProvider).data?.value ?? [];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(Icons.favorite_rounded),
        if (restaurants.isNotEmpty)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${restaurants.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
