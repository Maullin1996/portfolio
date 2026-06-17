import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Pumps the real [PortfolioApp] (not a hand-rolled `MaterialApp` wrapper —
/// see `app_dialog_provider_test.dart` for why that matters) at [size].
///
/// Disables [VisibilityDetectorController]'s periodic timer first:
/// `RevealOnScroll` mounts a `VisibilityDetector` per section, and that
/// timer reschedules itself for as long as any are mounted — fine in a
/// real app, but it trips flutter_test's "no pending timers after the
/// test" check. This is the workaround documented by the package itself.
Future<void> pumpPortfolioApp(WidgetTester tester, Size size) async {
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  await AtomicDesignConfig.initializeFromAsset(
    'assets/config/app_config.json',
  );
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
}
