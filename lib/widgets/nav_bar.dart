import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout/portfolio_section.dart';

/// The top bar of the portfolio: brand on the left, nav links (or a
/// hamburger on mobile) in the middle/right, and a light/dark toggle.
class PortfolioNavBar extends StatelessWidget {
  final bool isMobile;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final ValueChanged<PortfolioSection> onNavTap;
  final VoidCallback? onMenuTap;

  const PortfolioNavBar({
    super.key,
    required this.isMobile,
    required this.isDark,
    required this.onToggleTheme,
    required this.onNavTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.smallMedium,
            vertical: tokens.spacing.xSmall,
          ),
          child: Row(
            children: [
              AppText.h6('</> Portafolio', fontWeight: FontWeight.w700),
              const Spacer(),
              if (isMobile)
                IconButton(
                  onPressed: onMenuTap,
                  icon: Icon(Icons.menu, color: colors.textPrimary),
                )
              else
                for (final section in PortfolioSection.values)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacing.xSmall,
                    ),
                    child: TextButton(
                      onPressed: () => onNavTap(section),
                      child: AppText.body(
                        section.label,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
              SizedBox(width: tokens.spacing.xSmall),
              IconButton(
                tooltip: isDark ? 'Tema claro' : 'Tema oscuro',
                onPressed: onToggleTheme,
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
