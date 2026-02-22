// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:arenaone/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Initial screen builds correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ArenaOneApp());

    // Allow for any timers or initial store actions
    await tester.pump();

    // Verify that we are on the Home screen
    expect(find.byIcon(Icons.home), findsOneWidget);
    
    // Check for the initial empty state message
    expect(find.text('There are no upcoming matches in this league'), findsOneWidget);
  });
}
