// Mocks generated by Mockito 5.0.7 from annotations
// in restaurant/test/data/providers/restaurant_provider_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:restaurant/data/model/restaurant.dart' as _i2;
import 'package:restaurant/data/repositories/restaurant_repository.dart' as _i3;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeRestaurant extends _i1.Fake implements _i2.Restaurant {}

/// A class which mocks [RestaurantRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRestaurantRepository extends _i1.Mock
    implements _i3.RestaurantRepository {
  MockRestaurantRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Restaurant>> getAllRestaurants() => (super.noSuchMethod(
          Invocation.method(#getAllRestaurants, []),
          returnValue: Future<List<_i2.Restaurant>>.value(<_i2.Restaurant>[]))
      as _i4.Future<List<_i2.Restaurant>>);
  @override
  _i4.Future<List<_i2.Restaurant>> searchRestaurant(String? query) =>
      (super.noSuchMethod(Invocation.method(#searchRestaurant, [query]),
              returnValue:
                  Future<List<_i2.Restaurant>>.value(<_i2.Restaurant>[]))
          as _i4.Future<List<_i2.Restaurant>>);
  @override
  _i4.Future<_i2.Restaurant?> getRestaurant(String? id) =>
      (super.noSuchMethod(Invocation.method(#getRestaurant, [id]),
              returnValue: Future<_i2.Restaurant?>.value(_FakeRestaurant()))
          as _i4.Future<_i2.Restaurant?>);
  @override
  _i4.Future<void> postReview(
          String? restaurantId, String? name, String? review) =>
      (super.noSuchMethod(
          Invocation.method(#postReview, [restaurantId, name, review]),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
}