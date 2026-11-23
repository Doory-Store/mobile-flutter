import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';

/// Heart over a product photo. The guest gate lives in the parent.
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    required this.selected,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  final bool selected;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = !widget.enabled
        ? tokens.textMuted
        : widget.selected
        ? tokens.danger
        : scheme.onSurface;
    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      label: widget.selected
          ? DooryStrings.removeFavorite
          : DooryStrings.addFavorite,
      onTap: widget.enabled ? widget.onPressed : null,
      excludeSemantics: true,
      child: SizedBox(
        width: 48,
        height: 44,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled
              ? (_) => setState(() => _pressed = true)
              : null,
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.enabled ? widget.onPressed : null,
          child: Center(
            child: Opacity(
              opacity: _pressed ? 0.72 : 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                  boxShadow: DooryShadows.favorite(tokens.shadowFavorite),
                ),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(
                    widget.selected ? Icons.favorite : Icons.favorite_border,
                    size: DooryIconSize.inline,
                    color: color,
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
