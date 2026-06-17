import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/models/work_experience.dart';

/// The "Experiencia" section: a vertical timeline of roles followed by a
/// compact education/courses/languages card.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const _experience = [
    WorkExperience(
      role: 'Desarrollador Flutter',
      company: 'WhatsApp Backup Dashboard — Medellín',
      period: 'Sep. 2025 - Actual',
      summary:
          'Sistema de respaldo automático de evidencias de transacciones '
          'eliminadas en WhatsApp, con persistencia en Firebase y '
          'despliegue en Docker sobre Raspberry Pi.',
      isCurrent: true,
    ),
    WorkExperience(
      role: 'Desarrollador Flutter',
      company: 'Mecca — Medellín',
      period: 'Ene. 2026 - Feb. 2026',
      summary:
          'App de facturación para independientes, con reportes en PDF y '
          'operación 100% offline mediante SQLite.',
    ),
    WorkExperience(
      role: 'Desarrollador Flutter',
      company: 'PanelApp — Medellín',
      period: 'Abr. 2025 - Jul. 2025',
      summary:
          'Digitalización del control de producción: formularios '
          'dependientes, validaciones automáticas de peso y registro '
          'fotográfico de calidad.',
    ),
    WorkExperience(
      role: 'Desarrollador Flutter',
      company: 'Pay Track — Medellín',
      period: 'Ene. 2025 - Jun. 2025',
      summary:
          'Desarrollo de nuevas funcionalidades, pruebas unitarias y de '
          'widgets, y documentación técnica.',
    ),
    WorkExperience(
      role: 'Ingeniero de Diseño y Control Dimensional',
      company: 'Bauentech S.A.S — Girardota',
      period: 'Dic. 2023 - Dic. 2024',
      summary:
          'Herramientas digitales de control y seguimiento de procesos, y '
          'una primera app móvil en Flutter para registro de información — '
          'el punto de partida hacia el desarrollo de software.',
    ),
  ];

  static const _courses = [
    'Desarrollo de aplicaciones Flutter (Udemy)',
    'Flutter BLoC y Riverpod',
    'Análisis y visualización de datos con Python',
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 450
        ? tokens.spacing.xSmall
        : tokens.spacing.large;
    final maxContentWidth = (screenWidth - horizontalPadding * 2).clamp(
      0,
      800,
    );

    return Container(
      width: double.infinity,
      color: colors.surfaceMid,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: tokens.spacing.extraLarge,
      ),
      child: Column(
        children: [
          AppText.h2('Experiencia y Educación', fontWeight: FontWeight.w700),
          SizedBox(height: tokens.spacing.large),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth.toDouble()),
            child: Stack(
              children: [
                // The connecting line lives behind the items, spanning the
                // full stack height in one go — this avoids needing to
                // measure each item's height (the previous `IntrinsicHeight`
                // approach), which silently clipped text instead of wrapping
                // it once descriptions needed more lines on narrow screens.
                Positioned(
                  left: 6,
                  top: 7,
                  bottom: 7,
                  child: Container(width: 2, color: colors.border),
                ),
                Column(
                  children: [
                    for (var i = 0; i < _experience.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == _experience.length - 1
                              ? 0
                              : tokens.spacing.smallMedium,
                        ),
                        child: _TimelineItem(
                          experience: _experience[i],
                          maxWidth: maxContentWidth.toDouble(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.spacing.large),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth.toDouble()),
            child: const _EducationCard(courses: _courses),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final WorkExperience experience;

  /// The width available to this item (the timeline's `ConstrainedBox`
  /// width). Passed down explicitly and used to size the content column
  /// directly via `SizedBox` instead of `Expanded` — an ambient
  /// Stack→Column→Row chain doesn't reliably propagate a finite width this
  /// many levels down in this codebase (the same class of bug fixed in
  /// HeroSection), so the description rendered as a single unwrapped,
  /// ellipsized line instead of wrapping.
  final double maxWidth;

  const _TimelineItem({required this.experience, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    const railWidth = 14.0;
    final contentWidth = maxWidth - railWidth - tokens.spacing.smallMedium;
    // A Column's cross-axis isn't a reliable way to bound its grandchildren's
    // width in this codebase, even when the Column itself sits in a
    // width-constrained SizedBox (the same issue fixed in HeroSection) — so
    // every wrapping child below gets its own direct ConstrainedBox using
    // this value instead of inheriting it ambiently.
    final constraints = BoxConstraints(maxWidth: contentWidth);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Nudges the dot down to sit centered against the role/title
          // line instead of the row's very top.
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: railWidth,
            height: railWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
          ),
        ),
        SizedBox(width: tokens.spacing.smallMedium),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: constraints,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: tokens.spacing.xSmall,
                children: [
                  AppText.h6(
                    experience.role,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                  ),
                  if (experience.isCurrent)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spacing.xSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(
                          tokens.radius.extraLarge,
                        ),
                      ),
                      child: AppText.caption(
                        'Actual',
                        color: colors.onPrimary,
                      ),
                    ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: constraints,
              child: AppText.label(
                '${experience.company} · ${experience.period}',
                color: colors.primary,
                // AppText always forces overflow: ellipsis; without an
                // explicit maxLines, Flutter collapses the text to a single
                // line + "…" regardless of available width (the real cause
                // of the clipping bug — width was never the problem here).
                maxLines: 2,
              ),
            ),
            SizedBox(height: tokens.spacing.xSmall),
            ConstrainedBox(
              constraints: constraints,
              child: AppText.body(
                experience.summary,
                color: colors.textSecondary,
                maxLines: 6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  final List<String> courses;

  const _EducationCard({required this.courses});

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
          AppText.h6('Educación', color: colors.primary, fontWeight: FontWeight.w600),
          SizedBox(height: tokens.spacing.xSmall),
          AppText.body('Ingeniero Mecánico', fontWeight: FontWeight.w600),
          AppText.label(
            'Universidad de Antioquia · Diciembre de 2023',
            color: colors.textSecondary,
            // See the timeline summary above: AppText always sets
            // overflow: ellipsis, so any text that might need 2 lines must
            // get an explicit maxLines or it silently collapses to 1.
            maxLines: 2,
          ),
          SizedBox(height: tokens.spacing.smallMedium),
          Divider(color: colors.divider),
          SizedBox(height: tokens.spacing.smallMedium),
          AppText.h6('Cursos', color: colors.primary, fontWeight: FontWeight.w600),
          SizedBox(height: tokens.spacing.xSmall),
          for (final course in courses)
            Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.xSmall / 2),
              child: AppText.body(
                '• $course',
                color: colors.textSecondary,
                maxLines: 2,
              ),
            ),
          SizedBox(height: tokens.spacing.small),
          Divider(color: colors.divider),
          SizedBox(height: tokens.spacing.smallMedium),
          AppText.h6('Idiomas', color: colors.primary, fontWeight: FontWeight.w600),
          SizedBox(height: tokens.spacing.xSmall),
          Wrap(
            spacing: tokens.spacing.xSmall,
            runSpacing: tokens.spacing.xSmall,
            children: const [
              AppChip(label: 'Español — Nativo'),
              AppChip(label: 'Inglés — B1'),
            ],
          ),
        ],
      ),
    );
  }
}
