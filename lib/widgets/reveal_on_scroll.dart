import 'package:atomic_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and slides [child] up into place the first time it scrolls into
/// view, then stays put — it doesn't re-trigger on subsequent scrolls past
/// the same widget.
///
/// `key` is required (not just `super.key` as an optional override): it's
/// forwarded to the underlying [VisibilityDetector], which needs a stable,
/// unique key per instance to track visibility — reusing a default/null key
/// across multiple sections would make them share (and clobber) state.
class RevealOnScroll extends StatefulWidget {
  final Widget child;

  const RevealOnScroll({required Key key, required this.child})
    : super(key: key);

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_revealed && info.visibleFraction > 0.15) {
      _revealed = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: _onVisibilityChanged,
      // Isolates the animated opacity/translation into its own compositor
      // layer so the engine can re-blend it per frame instead of
      // re-rasterizing this whole (often heavy) section subtree.
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Opacity(
            opacity: _fade.value,
            child: FractionalTranslation(
              translation: _slide.value,
              child: child,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
