import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('experience section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpPortfolioApp(tester, const Size(390, 3200));
    expect(tester.takeException(), isNull);

    // Regression check: AppText always sets overflow: ellipsis, so any
    // AppText call without an explicit `maxLines` silently collapses to a
    // single line + "…" regardless of available width — no exception is
    // thrown, so `takeException` alone can't catch it. A single line is
    // ~20px tall; wrapped across several lines it should be well over that.
    const summary =
        'Sistema de respaldo automático de evidencias de transacciones '
        'eliminadas en WhatsApp, con persistencia en Firebase y '
        'despliegue en Docker sobre Raspberry Pi.';
    final height = tester.getSize(find.text(summary)).height;
    expect(
      height,
      greaterThan(40),
      reason: 'description looks like a single truncated line, not wrapped',
    );
  });

  testWidgets('experience section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await pumpPortfolioApp(tester, const Size(1280, 2400));
    expect(tester.takeException(), isNull);
  });
}
