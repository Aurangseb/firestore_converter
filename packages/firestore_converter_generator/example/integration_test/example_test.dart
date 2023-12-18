import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tap on the floating action button, verify new entry', (tester) async {
    // Load app widget.
    await tester.pumpWidget(const MyApp());

    // Finds the floating action button to tap on.
    final fab = find.byKey(const Key('addButton'));

    // Emulate a tap on the floating action button.
    await tester.tap(fab);

    // Wait 1 second for the SnackBar to be displayed
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify if appropriate message appears.
    expect(find.text('New user added'), findsOneWidget);
  });
}
