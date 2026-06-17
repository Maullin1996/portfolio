import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/models/project.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// The "Proyectos" section: real shipped projects in a responsive grid, each
/// linking to its source on GitHub and, when available, an inline YouTube
/// demo opened in a dialog.
///
/// Built with a [Wrap] instead of `AppGridView`: this section lives inside
/// the page's single outer [SingleChildScrollView] (see `PortfolioShell`),
/// which gives it unbounded height — `AppGridView`'s internal `GridView`
/// isn't shrink-wrapped and assumes a bounded-height host (a full screen
/// body), so it doesn't nest here. With only a handful of cards, a `Wrap`
/// gives the same responsive-column look without that constraint.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _projects = [
    Project(
      title: 'WhatsApp Backup Dashboard',
      description:
          'Respaldo automático de evidencias de transacciones eliminadas en '
          'WhatsApp, con persistencia en Firebase y despliegue en Docker '
          'sobre un servidor en Hetzner.',
      stack: ['Flutter', 'Firebase', 'Docker', 'Raspberry Pi'],
      githubUrl: 'https://github.com/Maullin1996/whatsapp-backup-dashboard',
      logoAsset: 'assets/images/whatsapp_dash_board_logo.webp',
      youtubeVideoId: 'ULHUtMTEWQU',
    ),
    Project(
      title: 'Mecca',
      description:
          'App de facturación para independientes: gestión de servicios y '
          'costos, reportes en PDF y operación 100% offline con SQLite.',
      stack: ['Flutter', 'SQLite', 'PDF'],
      githubUrl: 'https://github.com/Maullin1996/mecca-invoicing-app',
      logoAsset: 'assets/images/mecca_logo.webp',
      youtubeVideoId: '8Q86RFpOHBo',
    ),
    Project(
      title: 'PanelApp',
      description:
          'Sistema de trazabilidad de producción: formularios dependientes, '
          'validaciones automáticas de peso y registro fotográfico para '
          'control de calidad.',
      stack: ['Flutter', 'Riverpod', 'Firebase'],
      githubUrl: 'https://github.com/Maullin1996/panelapp-trazabilidad',
      logoAsset: 'assets/images/panelapp_logo.webp',
      youtubeVideoId: 'enNVjhjFtxQ',
    ),
    Project(
      title: 'Atomic Design',
      description:
          'El design system propio que usé para construir este portafolio: '
          'átomos, moléculas y organismos reutilizables en Flutter.',
      stack: ['Flutter', 'Design System'],
      githubUrl: 'https://github.com/Maullin1996/atomic_design',
      logoAsset: 'assets/images/atomic_design_logo.webp',
      // Sin demo todavía — el botón de reproducción queda visible pero
      // deshabilitado hasta que grabemos el video.
    ),
  ];

  /// Unlike `AppGridView`'s generic 360/600/840 thresholds, these cards carry
  /// a title, a multi-line description, tech chips, and two action buttons —
  /// they need much more room per column before splitting. Two columns at a
  /// typical phone width left the action row too narrow and overflowed.
  static int _columnCount(double width) {
    if (width < 600) return 1;
    if (width < 1024) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600
        ? tokens.spacing.xSmall
        : tokens.spacing.large;
    final availableWidth = screenWidth - horizontalPadding * 2;
    final columns = _columnCount(screenWidth);
    final cardWidth =
        (availableWidth - (columns - 1) * tokens.spacing.smallMedium) /
        columns;

    return Container(
      width: double.infinity,
      color: colors.surfaceMid,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: tokens.spacing.extraLarge,
      ),
      child: Column(
        children: [
          AppText.h2('Proyectos', fontWeight: FontWeight.w700),
          SizedBox(height: tokens.spacing.smallMedium),
          Wrap(
            spacing: tokens.spacing.smallMedium,
            runSpacing: tokens.spacing.smallMedium,
            children: [
              for (final project in _projects)
                SizedBox(
                  width: cardWidth,
                  child: _ProjectCard(project: project),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final hasDemo = project.youtubeVideoId != null;
    // Source logos run up to ~1450x1460 for a 40x40 thumbnail — decoding at
    // full resolution on every reveal is what causes the scroll-in jank.
    final logoCacheSize = (40 * MediaQuery.devicePixelRatioOf(context)).round();

    return AppCard(
      padding: EdgeInsets.all(tokens.spacing.smallMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(tokens.radius.medium),
                child: AppAssetsImage(
                  path: project.logoAsset,
                  widthImage: 40,
                  heightImage: 40,
                  cacheWidth: logoCacheSize,
                  cacheHeight: logoCacheSize,
                  fit: BoxFit.cover,
                  errorWidget: Icon(
                    Icons.apps,
                    size: 40,
                    color: colors.textDisabled,
                  ),
                ),
              ),
              SizedBox(width: tokens.spacing.small),
              Expanded(
                child: AppText.h6(
                  project.title,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.xSmall),
          AppText.body(
            project.description,
            color: colors.textSecondary,
            maxLines: 6,
          ),
          SizedBox(height: tokens.spacing.small),
          Wrap(
            spacing: tokens.spacing.xSmall,
            runSpacing: tokens.spacing.xSmall,
            children: [
              for (final tech in project.stack) AppChip(label: tech, backgroundColor: colors.primary, textColor: colors.onPrimary,),
            ],
          ),
          SizedBox(height: tokens.spacing.small),
          // Wrap instead of Row: a Row here previously overflowed when a
          // card ended up narrow (e.g. 2-column mobile layouts), since
          // neither button shrinks. Wrap just drops to a second line instead
          // of clipping.
          Wrap(
            spacing: tokens.spacing.xSmall,
            runSpacing: tokens.spacing.xSmall,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButtons(
                type: ButtonType.primaryImageButton,
                assetsIcon: 'assets/icons/github.svg',
                onPressed: () => _openGithub(project.githubUrl),
              ),
              Tooltip(
                message: hasDemo ? 'Ver demo' : 'Demo próximamente',
                child: AppButtons(
                  type: ButtonType.primaryIconButton,
                  icon: Icons.play_circle_fill,
                  iconSize: 60,
                  color: hasDemo ? Colors.red : colors.textDisabled,
                  onPressed: hasDemo
                      ? () => _showDemo(context, project)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openGithub(String url) {
    return launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }

  Future<void> _showDemo(BuildContext context, Project project) {
    return AppDialog.show(
      context,
      title: project.title,
      confirmLabel: 'Cerrar',
      onConfirm: () => Navigator.of(context).pop(),
      content: _DemoPlayer(videoId: project.youtubeVideoId!),
    );
  }
}

/// Owns the [YoutubePlayerController] lifecycle for a single dialog instance:
/// created when the demo opens, closed when the dialog is dismissed.
class _DemoPlayer extends StatefulWidget {
  final String videoId;

  const _DemoPlayer({required this.videoId});

  @override
  State<_DemoPlayer> createState() => _DemoPlayerState();
}

class _DemoPlayerState extends State<_DemoPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(controller: _controller, aspectRatio: 16 / 9);
  }
}
