import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:restaurant/common/date_time_helper.dart';
import 'package:restaurant/data/services/notification_service.dart';
import 'package:restaurant/data/repositories/repositories.dart';

class BackgroundServices {
  static const RANDOM_RESTAURANT_RECOMENDATION_NOTIFICATION_ID = 1;

  static Future<void> scheduleRandomRestaurantNotification() async {
    await AndroidAlarmManager.periodic(
      Duration(days: 1),
      RANDOM_RESTAURANT_RECOMENDATION_NOTIFICATION_ID,
      _showRandomRestaurantNotificationCallback,
      startAt: DateTimeHelper.fromNextHour('11:00:00'),
      // startAt: DateTime.now().add(Duration(seconds: 5)),
      exact: true,
      wakeup: true,
    );
  }

  static Future<void> cancelRandomRestaurantNotificationSchedule() async {
    await AndroidAlarmManager.cancel(
      RANDOM_RESTAURANT_RECOMENDATION_NOTIFICATION_ID,
    );
  }

  static Future<void> _showRandomRestaurantNotificationCallback() async {
    final results = await RestaurantRepository().getAllRestaurants();
    final randomRestaurant = results[Random().nextInt(results.length)];

    final notificationService = NotificationService();

    await notificationService.initialize();

    await notificationService.showRestaurantNotification(
      randomRestaurant,
    );
  }
}
