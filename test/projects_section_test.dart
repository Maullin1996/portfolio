import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/sections/projects_section.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('projects section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(tester, const ProjectsSection(), const Size(390, 1600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('projects section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpSection(
      tester,
      const ProjectsSection(),
      const Size(1280, 1200),
    );
    expect(tester.takeException(), isNull);
  });
}
