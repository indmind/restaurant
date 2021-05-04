import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  String? name;

  Food({this.name});

  factory Food.fromJson(Map<String, dynamic> data) => _$FoodFromJson(data);

  Map<String, dynamic> toJson() => _$FoodToJson(this);
}
