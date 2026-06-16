import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout/breakpoints.dart';
import 'package:portfolio/layout/portfolio_section.dart';
import 'package:portfolio/sections/hero_section.dart';
import 'package:portfolio/sections/section_placeholder.dart';
import 'package:portfolio/theme/theme_controller.dart';
import 'package:portfolio/widgets/nav_bar.dart';

/// The single-page scroll shell: nav bar (or drawer on mobile) + a vertical
/// stack of sections. Nav taps scroll smoothly to the matching section.
class PortfolioShell extends StatefulWidget {
  final ThemeController themeController;

  const PortfolioShell({super.key, required this.themeController});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  void _scrollToSection(PortfolioSection section) {
    final ctx = _sectionKeys[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: AppAnimations.slow,
      curve: AppAnimations.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeController,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Scaffold(
          key: _scaffoldKey,
          drawer: isMobile ? _buildDrawer() : null,
          body: Column(
            children: [
              PortfolioNavBar(
                isMobile: isMobile,
                isDark: isDark,
                onToggleTheme: widget.themeController.toggle,
                onNavTap: _scrollToSection,
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final section in PortfolioSection.values)
                        KeyedSubtree(
                          key: _sectionKeys[section],
                          child: section == PortfolioSection.home
                              ? HeroSection(
                                  onViewProjects: () => _scrollToSection(
                                    PortfolioSection.projects,
                                  ),
                                )
                              : SectionPlaceholder(section: section),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return AppDrawer(
      items: [
        for (final section in PortfolioSection.values)
          DrawerItem(
            icon: _iconFor(section),
            label: section.label,
            onTap: () => _scrollToSection(section),
          ),
      ],
    );
  }

  IconData _iconFor(PortfolioSection section) => switch (section) {
    PortfolioSection.home => Icons.home_outlined,
    PortfolioSection.projects => Icons.work_outline,
    PortfolioSection.about => Icons.person_outline,
    PortfolioSection.experience => Icons.timeline_outlined,
    PortfolioSection.contact => Icons.mail_outline,
  };
}
