import 'package:flutter/material.dart';
import 'package:restaurant/common/urls.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/ui/widgets/restaurant_start.dart';
import 'package:restaurant/ui/pages/restaurant_detail/restaurant_detail_page.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantListItem({required this.restaurant});

  final double _contentHeight = 84.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                RestaurantDetailPage(restaurantId: restaurant.id!),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        child: Row(
          children: [
            if (restaurant.pictureId != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Hero(
                  tag: restaurant.pictureId!,
                  child: Image.network(
                    '$kBaseUrl/images/small/' + restaurant.pictureId!,
                    width: _contentHeight,
                    height: _contentHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 14)
            ],
            Expanded(
              child: SizedBox(
                height: _contentHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          restaurant.name ?? '-',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        RestaurantStar(restaurant: restaurant),
                      ],
                    ),
                    SizedBox(height: 4),
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
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        restaurant.description ?? '-',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
