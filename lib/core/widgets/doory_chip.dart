import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

/// 30 dp chip inside a 48 dp target.
class DooryChip extends StatefulWidget {
  const DooryChip({
    required this.label,
    this.selected = false,
    this.enabled = true,
    this.leading,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final IconData? leading;
  final VoidCallback? onTap;

  static const visualKey = ValueKey<String>('doory-chip-visual');

  @override
  State<DooryChip> createState() => _DooryChipState();
}

class _DooryChipState extends State<DooryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final Color fill;
    final Color foreground;
    BorderSide? side;
    if (!widget.enabled) {
      fill = tokens.surfaceSubtle;
      foreground = tokens.textMuted;
    } else if (widget.selected) {
      fill = _pressed ? tokens.primaryHover : scheme.primary;
      foreground = scheme.onPrimary;
    } else {
      fill = _pressed ? tokens.primarySubtle : scheme.surface;
      foreground = scheme.onSurface;
      side = BorderSide(color: scheme.outline);
    }
    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.enabled
            ? () {
                setState(() => _pressed = false);
                widget.onTap?.call();
              }
            : null,
        child: SizedBox(
          height: 48,
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Material(
              key: DooryChip.visualKey,
              color: fill,
              shape: StadiumBorder(side: side ?? BorderSide.none),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leading != null) ...[
                        Icon(widget.leading, size: 16, color: foreground),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DooryTypography.chipLabel(
                            context,
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
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
