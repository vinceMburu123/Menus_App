import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menu_app/main.dart'; 

void main() {
  testWidgets('Menu items are displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the menu items are displayed.
    expect(find.byKey(const Key('Pizza')), findsOneWidget);
    expect(find.byKey(const Key('Burger')), findsOneWidget);
    expect(find.byKey(const Key('Pasta')), findsOneWidget);
    expect(find.byKey(const Key('Salad')), findsOneWidget);

    // Tap the Pizza menu item and trigger a frame.
    await tester.tap(find.byKey(const Key('Pizza')));
    await tester.pumpAndSettle();

    // Verify that the detail screen is displayed with the correct content.
    expect(find.byKey(const Key('detail-title')), findsOneWidget);
    expect(find.text('Delicious cheese pizza'), findsOneWidget);
  });
}
