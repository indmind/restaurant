import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant/data/db.dart';
import 'package:restaurant/data/providers/db_provider.dart';

import 'package:restaurant/ui/pages/home/home_page.dart';
import 'package:restaurant/ui/styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await openDatabaseConnection();

  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
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
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        textTheme: kTextTheme,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}
