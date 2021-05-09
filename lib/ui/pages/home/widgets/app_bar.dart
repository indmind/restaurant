import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/providers.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double topSafeAreaHeight;

  CustomSliverAppBarDelegate({
    required this.expandedHeight,
    required this.topSafeAreaHeight,
  });

  final double _searchFieldHeight = 48;
  final double _padding = 24.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(0, 3),
          blurRadius: 3.0,
          color: Colors.black.withOpacity(0.05),
        )
      ]),
      child: Stack(
        children: [
          _buildHeader(context, shrinkOffset),
          _buildSearchField(context, shrinkOffset),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double shrinkOffset) {
    return Positioned(
      bottom: _searchFieldHeight + 14 - shrinkOffset * 0.2,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: disappear(shrinkOffset),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: _padding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat pagi! Tio',
                    style: Theme.of(context).textTheme.overline,
                  ),
                  Text(
                    'Laper?',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Rekomendasi restoran untuk kamu!',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24.0,
                backgroundColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  double disappear(double shrinkOffset) {
    return shrinkOffset <= expandedHeight - 100
        ? (1 - shrinkOffset / (expandedHeight - 100))
        : 0;
  }

  Widget _buildSearchField(BuildContext context, double shrinkOffset) {
    return Positioned(
      bottom: 14,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: Container(
          height: _searchFieldHeight,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Cari",
              prefixIcon: Icon(Icons.search),
              filled: true,
              contentPadding: const EdgeInsets.all(0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(99.0),
                ),
              ),
            ),
            onChanged: (value) {
              EasyDebounce.debounce(
                'search-debounce',
                Duration(milliseconds: 500),
                () => context
                    .read(restaurantProvider.notifier)
                    .searchRestaurants(value),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => _searchFieldHeight + topSafeAreaHeight + _padding;

  @override
  bool shouldRebuild(CustomSliverAppBarDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight;
  }
}
