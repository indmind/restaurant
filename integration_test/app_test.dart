import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:restaurant/main.dart' as app;
import 'package:restaurant/ui/pages/home/widgets/restaurant_list.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Simple app test', (tester) async {
    await app.main();

    await tester.pumpAndSettle();

    final searchButton = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == 'Cari',
    );

    await tester.enterText(searchButton, 'melting');

    // wait for debounce
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(RestaurantList), findsOneWidget);
  });
}
