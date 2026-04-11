import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketledger/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('PocketLedger Smoke Test: Onboarding -> Dashboard', (WidgetTester tester) async {
    // Set initial preferences to show onboarding
    SharedPreferences.setMockInitialValues({'onboarding_done': false});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const PocketLedgerApp(showOnboarding: true));

    // Verify that onboarding is shown
    expect(find.text('Privacy First'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap 'Next' twice and then 'Get Started'
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Ultra Fast Logging'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Smart Analytics'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify that we are on the Dashboard
    expect(find.text('PocketLedger'), findsOneWidget);
    expect(find.text('Add Transaction'), findsOneWidget);
  });
}
