import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout/portfolio_shell.dart';
import 'package:portfolio/theme/theme_controller.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Portafolio',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: mode,
          // AppThemeProvider must live *inside* MaterialApp (not wrap it) so
          // that Theme.of(context) inside it resolves the brightness
          // MaterialApp just set — see atomic_design's own test_utils.dart.
          //
          // It's wired via `builder`, not `home`, because `builder` wraps the
          // whole Navigator (incl. its Overlay), while `home` only wraps the
          // initial route's content. Dialogs/routes pushed via showDialog are
          // inserted into that Overlay, *outside* of `home` — AppChip/AppCard
          // widgets used inside a dialog couldn't find the provider until
          // this moved here (e.g. the Proyectos demo video dialog).
          builder: (context, child) =>
              AppThemeProvider(child: child ?? const SizedBox.shrink()),
          home: PortfolioShell(themeController: _themeController),
        );
      },
    );
  }
}
