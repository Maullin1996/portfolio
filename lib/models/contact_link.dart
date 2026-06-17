import 'package:flutter/widgets.dart';

/// A single contact channel: a label, the URL it opens, and either a
/// bundled SVG asset (for brands atomic_design ships, e.g. WhatsApp/GitHub)
/// or a Material [IconData] fallback for the rest.
class ContactLink {
  final String label;
  final String url;
  final String? assetIcon;
  final IconData? icon;

  const ContactLink({
    required this.label,
    required this.url,
    this.assetIcon,
    this.icon,
  }) : assert(
         assetIcon != null || icon != null,
         'ContactLink needs either assetIcon or icon',
       );
}
