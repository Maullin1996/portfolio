import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout/portfolio_section.dart';

/// Temporary stand-in for a section that hasn't been built yet.
///
/// Lets us validate the nav + scroll + theme shell end-to-end before each
/// real section replaces its placeholder one feature at a time.
class SectionPlaceholder extends StatelessWidget {
  final PortfolioSection section;

  const SectionPlaceholder({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final isEven = section.index.isEven;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 480),
      color: isEven ? colors.background : colors.surfaceMid,
      padding: EdgeInsets.all(tokens.spacing.large),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.h2(section.label, color: colors.textPrimary),
          SizedBox(height: tokens.spacing.xSmall),
          AppText.body(
            'Sección "${section.label}" — próximamente',
            color: colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
