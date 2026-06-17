import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/sections/contact_section.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('contact section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(tester, const ContactSection(), const Size(390, 800));
    expect(tester.takeException(), isNull);

    for (final label in ['WhatsApp', 'LinkedIn', 'Email', 'GitHub']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('contact section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(tester, const ContactSection(), const Size(1280, 600));
    expect(tester.takeException(), isNull);
  });
}
