// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App starts and shows initial screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TravelMateApp());

    // TODO: Verify that your app's initial screen is rendered correctly.
    // For example, if you have an onboarding screen with a title:
    // expect(find.text('Welcome to TravelMate'), findsOneWidget);
  });
}
