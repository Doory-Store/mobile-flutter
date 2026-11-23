import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum DooryBadgeTone { neutral, danger, success, primary }

/// Small honest status label. No promotional copy is built in.
class DooryBadge extends StatelessWidget {
  const DooryBadge({
    required this.label,
    this.tone = DooryBadgeTone.neutral,
    super.key,
  });

  final String label;
  final DooryBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (fill, foreground) = switch (tone) {
      DooryBadgeTone.neutral => (tokens.surfaceSubtle, scheme.onSurfaceVariant),
      DooryBadgeTone.danger => (scheme.surface, tokens.danger),
      DooryBadgeTone.success => (tokens.successSurface, tokens.success),
      DooryBadgeTone.primary => (tokens.primarySubtle, tokens.cardPrice),
    };
    return Container(
      height: 18,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(tokens.radius4),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: DooryTypography.captionStrong(context)
            .copyWith(color: foreground),
      ),
    );
  }
}

/// Color-count mark. 28 dp painted, 44 dp to touch. Shown by the card when
/// more than one color exists.
class ColorCountBadge extends StatelessWidget {
  const ColorCountBadge({required this.count, this.onTap, super.key});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: onTap != null,
      label: DooryStrings.colorCount(count),
      excludeSemantics: true,
      child: SizedBox(
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surface,
                boxShadow: DooryShadows.favorite(tokens.shadowFavorite),
              ),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: Text(
                    '$count',
                    style: DooryTypography.captionStrong(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
