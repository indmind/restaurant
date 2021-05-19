import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/common/urls.dart';
import 'package:restaurant/data/custom_exception.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/data/providers/favorite_restaurants_provider.dart';
import 'package:restaurant/data/providers/restaurant_detail_provider.dart';
import 'package:restaurant/ui/pages/home/widgets/restaurant_list_item.dart';
import 'package:restaurant/ui/styles/colors.dart';

class RestaurantDetailPage extends HookWidget {
  final String restaurantId;

  RestaurantDetailPage({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final restaurantNotifier =
        useProvider(restaurantDetailFamily(restaurantId));

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: restaurantNotifier.when(
          data: (restaurant) => _buildPage(context, restaurant),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(
            child: Text((e as CustomException).message ?? 'Terjadi kesalahan'),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, Restaurant? restaurant) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(
              restaurant?.name ?? '-',
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
            actions: [
              if (restaurant != null)
                Consumer(
                  builder: (context, watch, child) {
                    // just to listen to favorite restaurant changes
                    watch(favoriteRestaurantProvider);

                    return IconButton(
                      onPressed: () {
                        context
                            .read(favoriteRestaurantProvider.notifier)
                            .toggle(restaurant);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: context
                                .read(favoriteRestaurantProvider.notifier)
                                .isFavorite(restaurant)
                            ? Colors.red
                            : Colors.white,
                      ),
                    );
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: restaurant != null
                  ? Hero(
                      tag: restaurant.pictureId!,
                      child: Image.network(
                        '$kBaseUrl/images/small/' + restaurant.pictureId!,
                        color: Colors.black.withOpacity(0.5),
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      restaurant?.name ?? '-',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  if (restaurant != null)
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
                    Text(restaurant?.city ?? '-'),
                  ],
                ),
              ),
              _sectionTitle(context, Icons.description_rounded, 'Deskripsi'),
              Text(
                restaurant?.description ?? '-',
              ),
              _sectionTitle(context, Icons.set_meal_rounded, 'Makanan'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (restaurant?.menu!.foods ?? [])
                    .map(
                      (food) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                children: (restaurant?.menu!.drinks ?? [])
                    .map(
                      (drink) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          drink.name!,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    )
                    .toList(),
              ),
              _sectionTitle(context, Icons.rate_review_rounded, 'Review'),
              _reviewField(context),
              SizedBox(height: 12.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: restaurant?.customerReviews?.length ?? 0,
                reverse: true,
                itemBuilder: (context, index) {
                  return ReviewItem(
                    review: restaurant!.customerReviews![index],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewField(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController = useTextEditingController();
    final reviewController = useTextEditingController();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nama',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value == '') {
                  return 'Harap isi nama Anda';
                }
              },
            ),
          ),
          TextFormField(
            controller: reviewController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Review Anda...',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (value) {
              if (value == null || value == '') {
                return 'Harap isi review Anda';
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              label: Text("Kirim"),
              icon: Icon(Icons.send),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  FocusScope.of(context).unfocus();

                  await context
                      .read(restaurantDetailFamily(restaurantId).notifier)
                      .postReview(nameController.text, reviewController.text);

                  nameController.clear();
                  reviewController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil mengirim review'),
                    ),
                  );
                } on CustomException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? 'Gagal mengirimkan review'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
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

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.name ?? '-',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 16,
                  color: Colors.grey[900],
                ),
          ),
          Text(review.date ?? '-', style: Theme.of(context).textTheme.caption),
          SizedBox(height: 4.0),
          Text(review.review ?? '-'),
        ],
      ),
    );
  }
}
