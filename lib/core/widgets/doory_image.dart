import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import 'skeleton.dart';

/// Product and tile image. The default well is 2:3 and cropped from the center.
class DooryImage extends StatelessWidget {
  const DooryImage({
    this.source,
    this.aspectRatio = 2 / 3,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.semanticLabel,
    super.key,
  });

  final String? source;
  final double aspectRatio;
  final BoxFit fit;
  final double radius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final image = AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dpr = MediaQuery.devicePixelRatioOf(context);
          final cacheWidth = constraints.maxWidth.isFinite
              ? (constraints.maxWidth * dpr).round()
              : null;
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: _body(context, cacheWidth),
          );
        },
      ),
    );
    if (semanticLabel == null || semanticLabel!.isEmpty) {
      return ExcludeSemantics(child: image);
    }
    return Semantics(label: semanticLabel, image: true, child: image);
  }

  Widget _body(BuildContext context, int? cacheWidth) {
    final source = this.source?.trim();
    if (source == null || source.isEmpty) return const _ImageFallback();
    final fade = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : DooryMotion.fade;
    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: fit,
        alignment: Alignment.center,
        gaplessPlayback: true,
        cacheWidth: cacheWidth,
        frameBuilder: (context, child, frame, wasSync) {
          if (wasSync || frame != null) {
            return AnimatedOpacity(opacity: 1, duration: fade, child: child);
          }
          return const _ImageLoading();
        },
        errorBuilder: (context, error, stackTrace) => const _ImageFallback(),
      );
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: source,
        fit: fit,
        alignment: Alignment.center,
        fadeInDuration: fade,
        fadeOutDuration: fade,
        memCacheWidth: cacheWidth,
        placeholder: (context, url) => const _ImageLoading(),
        errorWidget: (context, url, error) => const _ImageFallback(),
      );
    }
    return const _ImageFallback();
  }
}

class _ImageLoading extends StatelessWidget {
  const _ImageLoading();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(height: double.infinity, radius: 0, silent: true);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return ColoredBox(
      color: tokens.surfaceSubtle,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: DooryIconSize.empty,
          color: tokens.textMuted,
        ),
      ),
    );
  }
}
