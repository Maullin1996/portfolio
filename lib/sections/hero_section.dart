import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/layout/breakpoints.dart';

/// The "Inicio" section: name, role, a short professional tagline, the core
/// tech stack, a CTA into the Proyectos section, and a profile photo.
class HeroSection extends StatelessWidget {
  /// Invoked when the primary CTA ("Ver proyectos") is pressed.
  final VoidCallback onViewProjects;

  const HeroSection({super.key, required this.onViewProjects});

  static const _stack = ['Flutter', 'Dart', 'Firebase', 'Riverpod', 'SQLite'];

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final isDesktop = Breakpoints.isDesktop(context);
    final avatar = _Avatar(size: isDesktop ? 280 : 200);

    // Measured from MediaQuery rather than a LayoutBuilder around the
    // content: this Container centers its child via `alignment`, which
    // hands the child a loose-to-unbounded width, so a LayoutBuilder here
    // would just see an unusable max and the text below would never wrap.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableWidth = screenWidth - tokens.spacing.large * 2;
    final textMaxWidth = isDesktop
        ? availableWidth - avatar.size - tokens.spacing.extraLarge
        : availableWidth;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 560),
      color: colors.background,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.large,
        vertical: tokens.spacing.extraLarge,
      ),
      alignment: Alignment.center,
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _HeroText(
                  stack: _stack,
                  isDesktop: true,
                  maxWidth: textMaxWidth,
                  onViewProjects: onViewProjects,
                ),
                SizedBox(width: tokens.spacing.extraLarge),
                avatar,
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                avatar,
                SizedBox(height: tokens.spacing.large),
                _HeroText(
                  stack: _stack,
                  isDesktop: false,
                  maxWidth: textMaxWidth,
                  onViewProjects: onViewProjects,
                ),
              ],
            ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final double size;

  const _Avatar({required this.size});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ClipOval(
      child: AppAssetsImage(
        path: 'assets/images/avatar.jpg',
        widthImage: size,
        heightImage: size,
        fit: BoxFit.cover,
        errorWidget: Icon(
          Icons.person,
          size: size * 0.6,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final List<String> stack;
  final bool isDesktop;

  /// The width text/wrap children are pinned to. A Column's cross-axis
  /// "loose" constraint isn't reliably honored by large display text, so
  /// every wrapping child below is wrapped in its own `ConstrainedBox`
  /// using this value rather than relying on the ancestor alone.
  final double maxWidth;
  final VoidCallback onViewProjects;

  const _HeroText({
    required this.stack,
    required this.isDesktop,
    required this.maxWidth,
    required this.onViewProjects,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final align = isDesktop ? TextAlign.left : TextAlign.center;
    final crossAxis = isDesktop
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    final constraints = BoxConstraints(maxWidth: maxWidth);

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        ConstrainedBox(
          constraints: constraints,
          child: AppText.h1(
            'Mauricio Llanos',
            textAlign: align,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: tokens.spacing.xSmall),
        ConstrainedBox(
          constraints: constraints,
          child: AppText.h4(
            'Desarrollador Flutter',
            color: colors.primary,
            textAlign: align,
          ),
        ),
        SizedBox(height: tokens.spacing.medium),
        ConstrainedBox(
          constraints: constraints,
          child: AppText.bodyLg(
            'Construyo apps móviles end-to-end con Flutter y Firebase: desde el '
            'levantamiento de requisitos hasta la validación en producción, con '
            'foco en digitalizar procesos reales y automatizar operaciones.',
            color: colors.textSecondary,
            textAlign: align,
            maxLines: 4,
            softWrap: true,
          ),
        ),
        SizedBox(height: tokens.spacing.medium),
        ConstrainedBox(
          constraints: constraints,
          child: Wrap(
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            spacing: tokens.spacing.xSmall,
            runSpacing: tokens.spacing.xSmall,
            children: [
              for (final tech in stack)
                AppChip(
                  label: tech,
                  backgroundColor: colors.primary,
                  textColor: colors.onPrimary,
                ),
            ],
          ),
        ),
        SizedBox(height: tokens.spacing.large),
        AppButtons(
          type: ButtonType.primaryFillButton,
          title: const Text('Ver proyectos'),
          onPressed: onViewProjects,
        ),
      ],
    );
  }
}
