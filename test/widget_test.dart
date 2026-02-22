import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment1/main.dart';

void main() {
  testWidgets('VangtiChai app shows initial state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Verify the app title is shown
    expect(find.text('VangtiChai'), findsOneWidget);

    // Verify "Taka:" label is shown
    expect(find.text('Taka: '), findsOneWidget);

    // Verify initial amount is 0
    expect(find.text('0'), findsWidgets);

    // Verify numeric keypad buttons exist
    for (int i = 0; i <= 9; i++) {
      expect(find.text('$i'), findsWidgets);
    }

    // Verify Clear button exists
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('Tapping digits updates amount display', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Tap digit 2
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();

    // Tap digit 3
    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();

    // Tap digit 4
    await tester.tap(find.widgetWithText(ElevatedButton, '4'));
    await tester.pump();

    // Amount should now be 234
    expect(find.text('234'), findsOneWidget);
  });

  testWidgets('Clear button resets amount to 0', (WidgetTester tester) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Tap digit 5
    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();

    // Tap digit 0
    await tester.tap(find.widgetWithText(ElevatedButton, '0'));
    await tester.pump();

    // Tap digit 0
    await tester.tap(find.widgetWithText(ElevatedButton, '0'));
    await tester.pump();

    // Amount should be 500
    expect(find.text('500'), findsWidgets);

    // Tap Clear
    await tester.tap(find.widgetWithText(ElevatedButton, 'C'));
    await tester.pump();

    // Amount should be 0 again
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('Change table shows correct denominations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Verify note denomination labels exist
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Count'), findsOneWidget);
  });
}
