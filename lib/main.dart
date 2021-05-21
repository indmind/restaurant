import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/common/global_keys_helper.dart';
import 'package:restaurant/data/db.dart';
import 'package:restaurant/data/providers/providers.dart';
import 'package:restaurant/data/services/notification_service.dart';
import 'package:restaurant/ui/pages/home/home_page.dart';
import 'package:restaurant/ui/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: add native splashscreen
  final db = await openDatabaseConnection('restaurant.db');
  final preferences = await SharedPreferences.getInstance();

  await NotificationService().initialize();

  if (Platform.isAndroid) await AndroidAlarmManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalKeysHelper.appNav,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        textTheme: kTextTheme,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  StreamSubscription? subjectSubscription;

  @override
  void initState() {
    super.initState();

    subjectSubscription =
        NotificationService().configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }

  @override
  void dispose() {
    subjectSubscription?.cancel();

    super.dispose();
  }
}
