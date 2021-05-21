import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/providers/providers.dart';
import 'package:restaurant/data/services/background_services.dart';

class AppSettings extends ChangeNotifier {
  Reader _read;

  AppSettings(this._read);

  bool get isRestaurantRecomendationNotificationEnabled =>
      _read(preferencesProvider)
          .getBool('RESTAURANT_RECOMENDATION_NOTIFICATION') ??
      false;

  Future<void> toggleRestaurantRecomendationNotification(bool value) async {
    if (value == isRestaurantRecomendationNotificationEnabled) return;

    if (value) {
      await BackgroundServices.scheduleRandomRestaurantNotification();
    } else {
      await BackgroundServices.cancelRandomRestaurantNotificationSchedule();
    }

    await _read(preferencesProvider)
        .setBool('RESTAURANT_RECOMENDATION_NOTIFICATION', value);

    notifyListeners();
  }
}

final settingsProvider = ChangeNotifierProvider<AppSettings>((ref) {
  return AppSettings(ref.read);
});
