import 'package:flutter/material.dart';
import 'package:restaurant/ui/styles/styles.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
