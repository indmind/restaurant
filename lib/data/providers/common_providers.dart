import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final notificationProvider = Provider<NotificationService>(
  (_) => NotificationService(),
);

// implementation on main
final preferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

// implementation on main
final dbProvider = Provider<Database>(
  (ref) => throw UnimplementedError(),
);
