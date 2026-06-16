import 'package:flutter/widgets.dart';

/// Layout-level breakpoints for structural decisions (nav bar vs. drawer,
/// column counts, etc).
///
/// These mirror the same width scale used by `atomic_design`'s responsive
/// tokens (xSmall/small/medium/large/xLarge) so that token-driven spacing
/// and structural layout changes stay visually in sync.
abstract class Breakpoints {
  static const double small = 360;
  static const double medium = 414;
  static const double large = 600;
  static const double xLarge = 840;

  /// Below this width the nav collapses into a hamburger + drawer.
  ///
  /// This is intentionally higher than [large]: five nav links + the brand
  /// text + the theme toggle need more room than the design system's own
  /// "large" breakpoint gives them. Below ~840px the inline row overflows
  /// (verified: "Contacto" starts colliding with the theme icon under
  /// 748px, and the icon gets pushed out entirely by ~653px), so the nav
  /// switches to the hamburger well before that happens.
  static const double navCollapse = xLarge;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < navCollapse;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= navCollapse;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= xLarge;
}
