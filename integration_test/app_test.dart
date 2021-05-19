import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:restaurant/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Simple app test', (tester) async {
    app.main();

    await tester.pumpAndSettle();

    final searchButton = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Cari',
    );

    await tester.enterText(searchButton, 'melting');

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // TODO: write other test
  });
}
