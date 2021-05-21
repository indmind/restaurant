import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/common/global_keys_helper.dart';
import 'package:restaurant/data/model/models.dart';
import 'package:restaurant/ui/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class NotificationService {
  late FlutterLocalNotificationsPlugin _notificationInstance;

  static NotificationService? _instance;

  NotificationService._internal() {
    _instance = this;
    _notificationInstance = FlutterLocalNotificationsPlugin();
  }

  factory NotificationService() => _instance ?? NotificationService._internal();

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'random-restaurant',
    'Random Restaurant',
    'Show random restaurant every day!',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationInstance.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    final notificationAppLaunchDetails =
        await _notificationInstance.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      await onSelectNotification(notificationAppLaunchDetails!.payload);
    }
  }

  Future<dynamic> onSelectNotification(payload) async {
    if (payload == null) return;

    selectNotificationSubject.add(payload);
  }

  Future<void> showRestaurantNotification(Restaurant restaurant) {
    return _notificationInstance.show(
      1,
      restaurant.name,
      restaurant.description,
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: jsonEncode(restaurant.toJson()),
    );
  }

  StreamSubscription configureSelectNotificationSubject() {
    return selectNotificationSubject.stream.listen((String? payload) async {
      if (payload == null) return;

      final Restaurant restaurant = Restaurant.fromJson(jsonDecode(payload));

      GlobalKeysHelper.appNav.currentState?.push(
        MaterialPageRoute(
          builder: (context) =>
              RestaurantDetailPage(restaurantId: restaurant.id!),
        ),
      );
    });
  }
}
