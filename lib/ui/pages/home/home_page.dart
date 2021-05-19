import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/providers/providers.dart';

import 'widgets/app_bar.dart';
import 'widgets/restaurant_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () {
              return context
                  .read(restaurantProvider.notifier)
                  .loadRestaurants();
            },
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: CustomSliverAppBarDelegate(
                    expandedHeight: 240.0,
                    topSafeAreaHeight: MediaQuery.of(context).padding.top,
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer(
      builder: (context, watch, child) {
        final restaurants = watch(restaurantProvider);
        
        return restaurants.when(
          data: (restaurants) => restaurants.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text('Restoran tidak ditemukan...'),
                )
              : RestaurantList(restaurants: restaurants),
          loading: () => Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              (error as CustomException).message ?? 'Terjadi Kesalahan...',
            ),
          ),
        );
      },
    );
  }
}
