import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';

Future<void> _pumpApp(WidgetTester tester, Size size) async {
  await AtomicDesignConfig.initializeFromAsset(
    'assets/config/app_config.json',
  );
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('projects section at mobile width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _pumpApp(tester, const Size(390, 1600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('projects section at desktop width does not overflow', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    await _pumpApp(tester, const Size(1280, 1200));
    expect(tester.takeException(), isNull);
  });
}
