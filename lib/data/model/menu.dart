import 'package:json_annotation/json_annotation.dart';

import 'food.dart';
import 'drink.dart';

part 'menu.g.dart';

@JsonSerializable(explicitToJson: true)
class Menu {
  List<Food>? foods;
  List<Drink>? drinks;

  Menu({
    this.foods,
    this.drinks,
  });

  factory Menu.fromJson(Map<String, dynamic> data) => _$MenuFromJson(data);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
