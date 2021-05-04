// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    foods: (json['foods'] as List<dynamic>?)
        ?.map((e) => Food.fromJson(e as Map<String, dynamic>))
        .toList(),
    drinks: (json['drinks'] as List<dynamic>?)
        ?.map((e) => Drink.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'foods': instance.foods?.map((e) => e.toJson()).toList(),
      'drinks': instance.drinks?.map((e) => e.toJson()).toList(),
    };
