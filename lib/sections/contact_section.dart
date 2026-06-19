import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/models/contact_link.dart';
import 'package:url_launcher/url_launcher.dart';

/// The "Contacto" section plus the page footer: tappable contact channels
/// (WhatsApp, LinkedIn, Email, GitHub) followed by a small copyright bar.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static const _links = [
    ContactLink(
      label: '+57 311 3669344',
      url: 'https://wa.me/573113669344',
      assetIcon: 'assets/icons/whatsapp.svg',
    ),
    ContactLink(
      label: 'LinkedIn',
      // atomic_design doesn't bundle a LinkedIn svg (only whatsapp/github/x/
      // facebook/apple-mac/google-circle), so this one falls back to a
      // Material icon instead of assetIcon.
      url:
          'https://www.linkedin.com/in/mauricio-llanos-loaiza-3b0066296',
      icon: Icons.business_center_outlined,
    ),
    ContactLink(
      label: 'llanosmauricio10@gmail.com',
      url: 'mailto:llanosmauricio10@gmail.com',
      icon: Icons.email_outlined,
    ),
    ContactLink(
      label: 'Maullin1996',
      url: 'https://github.com/Maullin1996',
      assetIcon: 'assets/icons/github.svg',
    ),
  ];

  /// Same reasoning as `AboutSection._columnCount`: cards need real room
  /// before splitting into more than one column.

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 450
        ? tokens.spacing.xSmall
        : tokens.spacing.large;
    final maxTextWidth = (screenWidth - horizontalPadding * 2).clamp(
      0,
      600,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: colors.background,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: tokens.spacing.extraLarge,
          ),
          child: Column(
            children: [
              AppText.h2('Contacto', fontWeight: FontWeight.w700),
              SizedBox(height: tokens.spacing.small),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxTextWidth.toDouble(),
                ),
                child: AppText.bodyLg(
                  '¿Tienes un proyecto en mente? Escríbeme por cualquiera de '
                  'estos canales, te respondo lo antes posible.',
                  color: colors.textSecondary,
                  textAlign: TextAlign.center,
                  maxLines: 6,
                ),
              ),
              SizedBox(height: tokens.spacing.large),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1050,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: tokens.spacing.smallMedium,
                  runSpacing: tokens.spacing.smallMedium,
                  children: [
                    for (final link in _links)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 500,
                        ),
                        child: _ContactTile(link: link),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _Footer(),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final ContactLink link;

  const _ContactTile({required this.link});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);

    return AppCard(
      color: colors.surfaceMid,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.radius.small),
        onTap: () => _open(link.url),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.smallMedium,
            vertical: tokens.spacing.small,
          ),
          child: Row(
            children: [
              link.assetIcon != null
                  ? AppButtons(
                      type: ButtonType.primaryImageButton,
                      assetsIcon: link.assetIcon!,
                      onPressed: () => _open(link.url),
                    )
                  : AppButtons(
                      type: ButtonType.primaryIconButton,
                      icon: link.icon,
                      iconSize: 35,
                      onPressed: () => _open(link.url),
                    ),
              SizedBox(width: tokens.spacing.smallMedium),
              Expanded(
                child: SelectableText(
                  link.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(String url) {
    return launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final colors = AppColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 450
        ? tokens.spacing.xSmall
        : tokens.spacing.large;

    return Container(
      width: double.infinity,
      color: colors.surfaceMid,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: tokens.spacing.smallMedium,
      ),
      child: Center(
        child: AppText.caption(
          '© ${DateTime.now().year} Mauricio Llanos · Hecho con Flutter',
          color: colors.textSecondary,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}
