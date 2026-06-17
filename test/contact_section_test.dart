import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('contact section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpPortfolioApp(tester, const Size(390, 4400));
    expect(tester.takeException(), isNull);

    for (final label in ['WhatsApp', 'LinkedIn', 'Email', 'GitHub']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('contact section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpPortfolioApp(tester, const Size(1280, 3200));
    expect(tester.takeException(), isNull);
  });
}
