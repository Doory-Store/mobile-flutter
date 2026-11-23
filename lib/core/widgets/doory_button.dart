import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum DooryButtonVariant { primary, outline, secondary, text }

enum DooryButtonSize { h36, h40, h45, h48, h53 }

/// One button, four variants, five heights. The painted face keeps the
/// measured height; `h36` and `text` grow the hit target to 44 dp.
class DooryButton extends StatefulWidget {
  const DooryButton({
    required this.label,
    this.variant = DooryButtonVariant.primary,
    this.size = DooryButtonSize.h48,
    this.expanded = false,
    this.leading,
    this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final DooryButtonVariant variant;
  final DooryButtonSize size;
  final bool expanded;
  final IconData? leading;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  State<DooryButton> createState() => _DooryButtonState();
}

class _DooryButtonState extends State<DooryButton> {
  bool _pressed = false;
  bool _focused = false;

  double get _visual {
    return switch (widget.size) {
      DooryButtonSize.h36 => 36,
      DooryButtonSize.h40 => 40,
      DooryButtonSize.h45 => 45,
      DooryButtonSize.h48 => 48,
      DooryButtonSize.h53 => 53,
    };
  }

  double _radius(DooryTokens tokens) {
    return switch (widget.size) {
      DooryButtonSize.h36 => tokens.radius4,
      DooryButtonSize.h40 => tokens.radius6,
      DooryButtonSize.h45 => tokens.radiusCard,
      DooryButtonSize.h48 => tokens.radius6,
      DooryButtonSize.h53 => tokens.radiusCard,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null && !widget.loading;
    final visual = widget.variant == DooryButtonVariant.text
        ? math.max(_visual, 44.0)
        : _visual;
    final touch =
        widget.size == DooryButtonSize.h36 ||
            widget.variant == DooryButtonVariant.text
        ? math.max(visual, 44.0)
        : visual;
    final radius = _radius(tokens);
    final colors = _colors(tokens, scheme, enabled);
    final textStyle =
        (widget.size == DooryButtonSize.h36
                ? DooryTypography.buttonCompact(
                    context,
                    color: colors.foreground,
                  )
                : DooryTypography.button(context, color: colors.foreground))
            .copyWith(height: 1.05);
    final horizontal = widget.variant == DooryButtonVariant.text ? 8.0 : 16.0;

    final face = DooryButtonFace(
      height: visual,
      child: AnimatedContainer(
        duration: DooryMotion.press,
        curve: Curves.easeOut,
        height: visual,
        width: widget.expanded ? double.infinity : null,
        constraints: BoxConstraints(
          minWidth: widget.variant == DooryButtonVariant.text ? 0 : 64,
        ),
        decoration: BoxDecoration(
          color: _pressed && enabled ? colors.pressed : colors.fill,
          borderRadius: BorderRadius.circular(radius),
          border: colors.border == null
              ? null
              : Border.all(color: colors.border!, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: ClipRect(
          child: Center(
            child: widget.loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.spinner,
                      value: MediaQuery.disableAnimationsOf(context)
                          ? 0.65
                          : null,
                    ),
                  )
                : Row(
                    mainAxisSize: widget.expanded
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leading != null) ...[
                        Icon(
                          widget.leading,
                          size: DooryIconSize.inline,
                          color: colors.foreground,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.onPressed != null && !widget.loading,
      label: widget.loading ? DooryStrings.working : widget.label,
      excludeSemantics: true,
      child: Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: SizedBox(
          height: touch,
          width: widget.expanded ? double.infinity : null,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: enabled
                    ? (_) => setState(() => _pressed = true)
                    : null,
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                onTap: enabled ? widget.onPressed : null,
                child: face,
              ),
              if (_focused)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius + 2),
                        border: Border.all(color: scheme.primary, width: 2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _ButtonColors _colors(DooryTokens tokens, ColorScheme scheme, bool enabled) {
    final onStrong = scheme.onPrimary;
    if (!enabled && !widget.loading) {
      return switch (widget.variant) {
        DooryButtonVariant.primary => _ButtonColors(
          fill: scheme.outline,
          foreground: scheme.onSurfaceVariant,
          spinner: onStrong,
        ),
        DooryButtonVariant.outline => _ButtonColors(
          fill: Colors.transparent,
          foreground: tokens.textMuted,
          border: scheme.outline,
          spinner: scheme.primary,
        ),
        DooryButtonVariant.secondary => _ButtonColors(
          fill: tokens.surfaceSubtle,
          foreground: tokens.textMuted,
          spinner: scheme.primary,
        ),
        DooryButtonVariant.text => _ButtonColors(
          fill: Colors.transparent,
          foreground: tokens.textMuted,
          spinner: scheme.primary,
        ),
      };
    }
    return switch (widget.variant) {
      DooryButtonVariant.primary => _ButtonColors(
        fill: scheme.primary,
        pressed: tokens.primaryHover,
        foreground: onStrong,
        spinner: onStrong,
      ),
      DooryButtonVariant.outline => _ButtonColors(
        fill: Colors.transparent,
        pressed: tokens.primarySubtle,
        foreground: tokens.cardPrice,
        border: scheme.primary,
        spinner: scheme.primary,
      ),
      DooryButtonVariant.secondary => _ButtonColors(
        fill: scheme.surface,
        pressed: tokens.primarySubtle,
        foreground: scheme.onSurface,
        border: scheme.outlineVariant,
        spinner: scheme.primary,
      ),
      DooryButtonVariant.text => _ButtonColors(
        fill: Colors.transparent,
        pressed: tokens.primarySubtle,
        foreground: tokens.cardPrice,
        spinner: scheme.primary,
      ),
    };
  }
}

/// Painted face of [DooryButton], at the measured height.
class DooryButtonFace extends StatelessWidget {
  const DooryButtonFace({required this.height, required this.child, super.key});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _ButtonColors {
  const _ButtonColors({
    required this.fill,
    required this.foreground,
    required this.spinner,
    this.pressed,
    this.border,
  });

  final Color fill;
  final Color? pressed;
  final Color foreground;
  final Color? border;
  final Color spinner;
}
