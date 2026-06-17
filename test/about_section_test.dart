import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/sections/about_section.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('about section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(tester, const AboutSection(), const Size(390, 2400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('about section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(tester, const AboutSection(), const Size(1280, 1800));
    expect(tester.takeException(), isNull);
  });
}
