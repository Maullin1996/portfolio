import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/models/skill_category.dart';

/// The "Sobre mí" section: a short bio followed by categorized skill chips.
///
/// Follows the same `Wrap`-with-explicit-width pattern as `ProjectsSection`
/// rather than a plain `Column`/`Row` — this section also lives inside the
/// page's outer scroll view, so children only get *loose* width constraints
/// and large text/chips won't reliably wrap without a hard width.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _bio = [
    'Desarrollador Flutter con experiencia en la construcción de '
        'aplicaciones móviles en entornos reales, enfocado en digitalización '
        'de procesos, trazabilidad y automatización de operaciones.',
    'Experiencia desarrollando soluciones end-to-end con Flutter y '
        'Firebase, incluyendo levantamiento de requisitos, diseño de flujos '
        'de usuario, integración con APIs y validación en producción. '
        'Manejo de estado con Riverpod y enfoque en consistencia de datos y '
        'usabilidad.',
  ];

  static const _skillCategories = [
    SkillCategory(
      label: 'Mobile',
      skills: ['Flutter', 'Dart', 'Riverpod', 'Atomic Design'],
    ),
    SkillCategory(
      label: 'Backend & Datos',
      skills: ['Firebase', 'Firestore', 'Authentication', 'SQLite', 'APIs REST'],
    ),
    SkillCategory(
      label: 'Testing',
      skills: ['Unit Test', 'Widget Test', 'Integration Test'],
    ),
    SkillCategory(
      label: 'Herramientas & Infra',
      skills: ['Git', 'Docker', 'Raspberry Pi'],
    ),
  ];

  /// Same reasoning as `ProjectsSection._columnCount`: these blocks carry a
  /// category label plus a multi-chip `Wrap`, so they need real room before
  /// splitting into more than one column.
  static int _columnCount(double width) {
    if (width < 700) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 450
        ? tokens.spacing.xSmall
        : tokens.spacing.large;
    final availableWidth = screenWidth - horizontalPadding * 2;
    final columns = _columnCount(screenWidth);
    final blockWidth =
        (availableWidth - (columns - 1) * tokens.spacing.smallMedium) /
        columns;

    return Container(
      width: double.infinity,
      color: colors.background,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: tokens.spacing.extraLarge,
      ),
      child: Column(
        children: [
          AppText.h2('Sobre mí', fontWeight: FontWeight.w700),
          SizedBox(height: tokens.spacing.smallMedium),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: availableWidth.clamp(0, 700)),
            child: Column(
              children: [
                for (final paragraph in _bio)
                  Padding(
                    padding: EdgeInsets.only(bottom: tokens.spacing.small),
                    child: AppText.bodyLg(
                      paragraph,
                      color: colors.textSecondary,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: tokens.spacing.large),
          Wrap(
            spacing: tokens.spacing.smallMedium,
            runSpacing: tokens.spacing.smallMedium,
            children: [
              for (final category in _skillCategories)
                SizedBox(
                  width: blockWidth,
                  child: _SkillBlock(category: category),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillBlock extends StatelessWidget {
  final SkillCategory category;

  const _SkillBlock({required this.category});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);

    return AppCard(
      padding: EdgeInsets.all(tokens.spacing.smallMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.h6(
            category.label,
            color: colors.primary,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: tokens.spacing.small),
          Wrap(
            spacing: tokens.spacing.xSmall,
            runSpacing: tokens.spacing.xSmall,
            children: [
              for (final skill in category.skills) AppChip(label: skill, backgroundColor: colors.primary, textColor: colors.onPrimary),
            ],
          ),
        ],
      ),
    );
  }
}
