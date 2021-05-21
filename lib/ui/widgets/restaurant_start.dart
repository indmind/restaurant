import 'package:flutter/material.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/ui/styles/styles.dart';

class RestaurantStar extends StatelessWidget {
  RestaurantStar({
    Key? key,
    required this.restaurant,
  }) : super(key: key) {
    if ((restaurant.rating ?? 0) >= 4) {
      color = kPrimaryColor;
    } else if ((restaurant.rating ?? 0) > 3) {
      color = Color(0xFFFBAA60);
    } else {
      color = Colors.red;
    }
  }

  final Restaurant restaurant;
  late final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 14,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          restaurant.rating?.toString() ?? '-',
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}
