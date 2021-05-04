import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:restaurant/ui/pages/home/home_page.dart';
import 'package:restaurant/ui/styles/styles.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        textTheme: kTextTheme,
      ),
      home: HomePage(),
    );
  }
}
