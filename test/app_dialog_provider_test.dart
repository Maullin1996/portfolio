import 'dart:async';

import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/sections/projects_section.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('an AppDialog opens without throwing', (tester) async {
    // Regression test: AppDialog's build() used to throw "AppThemeProvider
    // no encontrado en el árbol" because showDialog inserts into the
    // Navigator's Overlay, which sits *outside* of MaterialApp.home — and
    // AppThemeProvider used to be wired there instead of via `builder`
    // (see lib/app.dart). Kept in its own file/process: pumping the real
    // PortfolioApp a 3rd time in the same test process hangs in this
    // environment (asset/image-cache contention across pumps), so this
    // can't just be a 3rd `testWidgets` case tacked onto
    // projects_section_test.dart.
    addTearDown(tester.view.reset);
    await pumpPortfolioApp(tester, const Size(1280, 1200));

    final context = tester.element(find.byType(ProjectsSection));
    unawaited(
      AppDialog.show(context, title: 'Test', content: const SizedBox()),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(AppDialog), findsOneWidget);
  });
}
