import 'package:json_annotation/json_annotation.dart';

part 'drink.g.dart';

@JsonSerializable()
class Drink {
  String? name;

  Drink({this.name});

  factory Drink.fromJson(Map<String, dynamic> data) => _$DrinkFromJson(data);

  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}
