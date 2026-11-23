import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';

/// Quiet placeholder. The shimmer stops when animations are disabled.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    required this.height,
    this.width,
    this.radius = 8,
    this.silent = false,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;
  final bool silent;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = !MediaQuery.disableAnimationsOf(context);
    if (!animate) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    _controller ??= AnimationController(
      vsync: this,
      duration: DooryMotion.shimmer,
    )..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final sized = widget.height.isFinite
        ? SizedBox(width: widget.width, height: widget.height)
        : const SizedBox.expand();
    final Widget box;
    if (_controller == null) {
      box = DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surfaceSubtle,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: sized,
      );
    } else {
      box = AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final t = _controller!.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              gradient: LinearGradient(
                begin: Alignment(-1.4 + (t * 2.8), 0),
                end: Alignment(-0.2 + (t * 2.8), 0),
                colors: [
                  tokens.surfaceSubtle,
                  tokens.surfaceSubtle,
                  Theme.of(context).colorScheme.surface,
                  tokens.surfaceSubtle,
                  tokens.surfaceSubtle,
                ],
                stops: const [0, 0.35, 0.5, 0.65, 1],
              ),
            ),
            child: child,
          );
        },
        child: sized,
      );
    }
    if (widget.silent) return box;
    return Semantics(
      label: DooryStrings.loading,
      container: true,
      child: ExcludeSemantics(child: box),
    );
  }
}

class SkeletonText extends StatelessWidget {
  const SkeletonText({this.widthFactor = 1, super.key});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: AlignmentDirectional.centerStart,
      child: const SkeletonBox(height: 12, radius: 4, silent: true),
    );
  }
}

enum SkeletonProductWidth { column, rail }

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({
    this.width = SkeletonProductWidth.column,
    super.key,
  });

  final SkeletonProductWidth width;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width == SkeletonProductWidth.rail ? 137.0 : 193.5;
    return Semantics(
      label: DooryStrings.loading,
      container: true,
      child: SizedBox(
        width: cardWidth,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: SkeletonBox(
                height: double.infinity,
                radius: 0,
                silent: true,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(),
                  SizedBox(height: 6),
                  SkeletonText(widthFactor: 0.6),
                  SizedBox(height: 6),
                  SkeletonText(widthFactor: 0.4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonListRow extends StatelessWidget {
  const SkeletonListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: DooryStrings.loading,
      container: true,
      child: const SizedBox(
        height: 56,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: SkeletonBox(height: 12, radius: 4, silent: true),
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonChip extends StatelessWidget {
  const SkeletonChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(width: 72, height: 30, radius: 999, silent: true);
  }
}
