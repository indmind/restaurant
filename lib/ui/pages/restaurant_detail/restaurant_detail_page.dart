import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/providers/providers.dart';
import 'package:restaurant/ui/pages/home/widgets/restaurant_list_item.dart';
import 'package:restaurant/ui/styles/colors.dart';

class RestaurantDetailPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        useProvider(selectedRestaurantProvider).state!;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                restaurant.name!,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
              ),
              brightness: Brightness.dark,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: restaurant.pictureId!,
                  child: Image.network(
                    restaurant.pictureId!,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name ?? '-',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    RestaurantStar(restaurant: restaurant),
                  ],
                ),
                Opacity(
                  opacity: 0.5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(restaurant.city ?? '-'),
                    ],
                  ),
                ),
                _sectionTitle(context, Icons.description_rounded, 'Deskripsi'),
                Text(
                  restaurant.description ?? '-',
                ),
                _sectionTitle(context, Icons.set_meal_rounded, 'Makanan'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (restaurant.menu!.foods ?? [])
                      .map(
                        (food) => Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            food.name!,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      )
                      .toList(),
                ),
                _sectionTitle(
                    context, Icons.emoji_food_beverage_rounded, 'Minuman'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (restaurant.menu!.drinks ?? [])
                      .map(
                        (drink) => Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            drink.name!,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 14.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: kPrimaryColor,
          ),
          SizedBox(width: 4.0),
          Text(
            text,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 18,
                  color: Colors.grey[900],
                ),
          ),
        ],
      ),
    );
  }
}
