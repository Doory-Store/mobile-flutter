import 'package:material_ui/material_ui.dart';

import 'doory_tokens.dart';

/// Cairo scale for the rebuild. Older names are aliases of the new roles
/// so existing screens follow the same sizes.
abstract final class DooryTypography {
  static const family = 'Cairo';

  static TextStyle _style({
    required double size,
    required double line,
    required FontWeight weight,
    required Color color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: const ['Tahoma', 'sans-serif'],
      fontSize: size,
      height: line / size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
      decoration: decoration,
      decorationColor: decoration == null ? null : color,
    );
  }

  static TextStyle wordmark(BuildContext context) => _style(
    size: 24,
    line: 32,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  static TextStyle wordmarkDisplay(BuildContext context) => _style(
    size: 40,
    line: 52,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  static TextStyle toolbarTitle(BuildContext context) => _style(
    size: 18,
    line: 24,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle sectionTitle(BuildContext context) => _style(
    size: 16,
    line: 22,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle rowLabel(BuildContext context) => _style(
    size: 15,
    line: 22,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle rowLabelStrong(BuildContext context) => _style(
    size: 15,
    line: 22,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle body(BuildContext context) => _style(
    size: 14,
    line: 20,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle bodySecondary(BuildContext context) => _style(
    size: 14,
    line: 20,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  static TextStyle cardTitle(BuildContext context) => _style(
    size: 12,
    line: 16,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardBrand(BuildContext context) => _style(
    size: 12,
    line: 16,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle price(BuildContext context) => _style(
    size: 14,
    line: 18,
    weight: FontWeight.w700,
    color: DooryTokens.of(context).cardPrice,
  );

  /// PDP and cart summary. Color is the adopted default in p0-decisions §3.
  static TextStyle priceLarge(BuildContext context) => _style(
    size: 18,
    line: 24,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  static TextStyle priceCompact(BuildContext context) => _style(
    size: 16,
    line: 20,
    weight: FontWeight.w700,
    color: DooryTokens.of(context).cardPrice,
  );

  static TextStyle strike(BuildContext context) => _style(
    size: 11,
    line: 14,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle caption(BuildContext context) => _style(
    size: 12,
    line: 16,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  static TextStyle captionStrong(BuildContext context) => _style(
    size: 11,
    line: 14,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle chipLabel(BuildContext context, {Color? color}) => _style(
    size: 13,
    line: 18,
    weight: FontWeight.w600,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle tabLabel(Color color) =>
      _style(size: 11, line: 14, weight: FontWeight.w600, color: color);

  static TextStyle button(BuildContext context, {Color? color}) => _style(
    size: 16,
    line: 22,
    weight: FontWeight.w700,
    color: color ?? Theme.of(context).colorScheme.onPrimary,
  );

  static TextStyle buttonCompact(BuildContext context, {Color? color}) =>
      _style(
        size: 14,
        line: 18,
        weight: FontWeight.w700,
        color: color ?? Theme.of(context).colorScheme.onPrimary,
      );

  static TextStyle link(BuildContext context) => _style(
    size: 14,
    line: 20,
    weight: FontWeight.w700,
    color: DooryTokens.of(context).cardPrice,
  );

  static TextStyle badgeCount(Color color) =>
      _style(size: 10, line: 12, weight: FontWeight.w700, color: color);

  // Older names, kept so current screens pick up the P0 scale.

  static TextStyle page(BuildContext context) => toolbarTitle(context);

  static TextStyle section(BuildContext context) => sectionTitle(context);

  static TextStyle shelf(BuildContext context) => sectionTitle(context);

  static TextStyle productTitle(BuildContext context) => rowLabel(context);

  static TextStyle pdpPrice(BuildContext context) => priceLarge(context);

  static TextStyle cardPrice(BuildContext context) => price(context);

  static TextStyle compactPrice(BuildContext context) => priceCompact(context);

  static TextStyle cta(BuildContext context) => button(context);

  static TextStyle label(BuildContext context) => bodySecondary(context);

  static TextStyle labelStrong(BuildContext context) => link(context);

  static TextStyle cardMeta(BuildContext context, {Color? color}) {
    final style = caption(context);
    if (color == null) return style;
    return style.copyWith(color: color, decorationColor: color);
  }

  static TextStyle shortcut(BuildContext context) => _style(
    size: 10,
    line: 13,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle navLabel(Color color) => tabLabel(color);
}
