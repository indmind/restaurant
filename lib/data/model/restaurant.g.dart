// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return Restaurant(
    id: json['id'] as String?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    pictureId: json['pictureId'] as String?,
    city: json['city'] as String?,
    rating: (json['rating'] as num?)?.toDouble(),
    menu: json['menus'] == null
        ? null
        : Menu.fromJson(json['menus'] as Map<String, dynamic>),
    customerReviews: (json['customerReviews'] as List<dynamic>?)
        ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'pictureId': instance.pictureId,
      'city': instance.city,
      'rating': instance.rating,
      'menus': instance.menu?.toJson(),
      'customerReviews':
          instance.customerReviews?.map((e) => e.toJson()).toList(),
    };
