import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant/data/model/models.dart';

void main() {
  final jsonString =
      '''
    {
      "id":"rqdv5juczeskfw1e867",
      "name":"Melting Pot",
      "description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
      "city":"Medan",
      "address":"Jln. Pandeglang no 19",
      "pictureId":"14",
      "categories":[
        {
            "name":"Italia"
        },
        {
            "name":"Modern"
        }
      ],
      "menus":{
        "foods":[
            {
              "name":"Paket rosemary"
            },
            {
              "name":"Toastie salmon"
            },
            {
              "name":"Bebek crepes"
            },
            {
              "name":"Salad lengkeng"
            }
        ],
        "drinks":[
            {
              "name":"Es krim"
            },
            {
              "name":"Sirup"
            },
            {
              "name":"Jus apel"
            },
            {
              "name":"Jus jeruk"
            },
            {
              "name":"Coklat panas"
            },
            {
              "name":"Air"
            },
            {
              "name":"Es kopi"
            },
            {
              "name":"Jus alpukat"
            },
            {
              "name":"Jus mangga"
            },
            {
              "name":"Teh manis"
            },
            {
              "name":"Kopi espresso"
            },
            {
              "name":"Minuman soda"
            },
            {
              "name":"Jus tomat"
            }
        ]
      },
      "rating":4.2,
      "customerReviews":[
        {
            "name":"Ahmad",
            "review":"Tidak rekomendasi untuk pelajar!",
            "date":"13 November 2019"
        },
        {
            "name":"Olan",
            "review":"Gretes place i've ever visit",
            "date":"21 Mei 2021"
        },
        {
            "name":"Ivan",
            "review":"owoowow",
            "date":"21 Mei 2021"
        },
        {
            "name":"Zikri",
            "review":"test",
            "date":"21 Mei 2021"
        },
        {
            "name":"Bang Jago",
            "review":"ass",
            "date":"21 Mei 2021"
        },
        {
            "name":"A",
            "review":"ASd",
            "date":"21 Mei 2021"
        }
      ]
    }
  ''';

  test('Restaurant model sould parse JSON correctly', () async {
    final Restaurant restaurant = Restaurant.fromJson(jsonDecode(jsonString));

    expect(restaurant.id, isNotEmpty);
    expect(restaurant.name, isNotEmpty);
    expect(restaurant.description, isNotEmpty);
    expect(restaurant.city, isNotEmpty);

    expect(restaurant.customerReviews, isA<List<Review>>());
    expect(restaurant.menu, isA<Menu>());
  });
}
