
import 'package:json_annotation/json_annotation.dart';

import 'menu.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;
  @JsonKey(name: 'menus')
  Menu? menu;

  Restaurant(
      {this.id,
      this.name,
      this.description,
      this.pictureId,
      this.city,
      this.rating,
      this.menu,});

  factory Restaurant.fromJson(Map<String, dynamic> data) => _$RestaurantFromJson(data);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
