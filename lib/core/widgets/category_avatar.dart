import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import '../../data/models/catalog_models.dart';

/// Circular category photo with a letter-on-pastel fallback.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    required this.name,
    this.imageUrl,
    this.size = 68,
    this.backgroundColor,
    this.showBorder = false,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final bool showBorder;

  String? get _url {
    final value = imageUrl?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  bool get _hasUrl => _url != null;

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '؟';
    return trimmed.characters.first;
  }

  @override
  Widget build(BuildContext context) {
    final pastels = DooryTokens.of(context).shortcutPastels;
    final fallback = _FallbackDisc(
      initial: _initial,
      color: backgroundColor ?? pastels.toneAt(0),
      style: _initialStyle(context),
    );
    return Semantics(
      label: name,
      image: _hasUrl,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder ? Border.all(color: pastels.border) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasUrl
            ? CachedNetworkImage(
                imageUrl: _url!,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                    .round()
                    .clamp(32, 512),
                placeholder: (context, _) => fallback,
                errorWidget: (context, _, _) => fallback,
              )
            : fallback,
      ),
    );
  }

  TextStyle _initialStyle(BuildContext context) {
    if (size >= 56) return DooryTypography.section(context);
    if (size >= 32) return DooryTypography.labelStrong(context);
    return DooryTypography.shortcut(context);
  }
}

class _FallbackDisc extends StatelessWidget {
  const _FallbackDisc({
    required this.initial,
    required this.color,
    required this.style,
  });

  final String initial;
  final Color color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(child: Text(initial, style: style)),
    );
  }
}

/// Category name chip with a leading avatar for rails, search, and listings.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.node,
    required this.onPressed,
    this.toneIndex,
    super.key,
  });

  final CategoryNode node;
  final VoidCallback onPressed;
  final int? toneIndex;

  @override
  Widget build(BuildContext context) {
    final pastels = DooryTokens.of(context).shortcutPastels;
    return ActionChip(
      avatar: CategoryAvatar(
        name: node.name,
        imageUrl: node.imageUrl,
        size: 24,
        backgroundColor: pastels.toneAt(toneIndex ?? node.id),
      ),
      label: Text(node.name),
      onPressed: onPressed,
    );
  }
}
