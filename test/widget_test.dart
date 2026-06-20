// Basic smoke test for the Sahaym app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a basic widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Sahaym'))),
    );

    expect(find.text('Sahaym'), findsOneWidget);
  });
}
