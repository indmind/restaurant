import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/providers/favorite_restaurants_provider.dart';
import 'package:restaurant/data/providers/providers.dart';
import 'package:restaurant/ui/pages/home/widgets/favorite_restaurant_badge.dart';
import 'package:restaurant/ui/styles/colors.dart';

import 'widgets/app_bar.dart';
import 'widgets/restaurant_list.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 2);
    final selected = useState(0);

    useEffect(() {
      controller.addListener(() {
        selected.value = controller.index;
      });
    }, []);

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
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: 24,
                  toolbarHeight: 24,
                  collapsedHeight: 24,
                  flexibleSpace: TabBar(
                    controller: controller,
                    labelPadding: const EdgeInsets.symmetric(vertical: 12),
                    indicatorColor: kPrimaryColor,
                    tabs: [
                      Tab(icon: Icon(Icons.restaurant_rounded)),
                      Tab(icon: FavoriteRestaurantBadge()),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: selected.value == 0
                        ? _buildRestaurantsTab()
                        : _buildFavoriteRestaurantsTab(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsTab() {
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
            child: Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
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

  Widget _buildFavoriteRestaurantsTab() {
    return Consumer(
      builder: (context, watch, child) {
        final restaurants = watch(favoriteRestaurantProvider);

        return restaurants.when(
          data: (restaurants) => restaurants.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text('Tidak terdapat restoran favorit...'),
                )
              : RestaurantList(
                  restaurants: restaurants,
                  dismissable: true,
                ),
          loading: () => Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
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
