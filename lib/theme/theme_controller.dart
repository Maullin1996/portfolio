import 'package:flutter/material.dart';

/// Holds the app-wide [ThemeMode] and notifies listeners on toggle.
///
/// Unlike [ThemeMode.system], this controller is driven explicitly by the
/// user via the toggle in the nav bar, defaulting to light.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}
