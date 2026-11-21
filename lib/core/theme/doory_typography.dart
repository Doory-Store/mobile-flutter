import 'package:material_ui/material_ui.dart';

import 'doory_tokens.dart';

/// Named styles from DESIGN.md §2. Letter-spacing stays 0. Height is unitless.
abstract final class DooryTypography {
  static const family = 'Cairo';

  static TextStyle _style({
    required double size,
    required double line,
    required FontWeight weight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      height: line / size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
    );
  }

  static TextStyle wordmark(BuildContext context) => _style(
    size: 24,
    line: 36,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.primary,
  );

  static TextStyle page(BuildContext context) => _style(
    size: 24,
    line: 36,
    weight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle section(BuildContext context) => _style(
    size: 22,
    line: 28,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle shelf(BuildContext context) => _style(
    size: 20,
    line: 24,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle body(BuildContext context) => _style(
    size: 16,
    line: 24,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle productTitle(BuildContext context) => _style(
    size: 20,
    line: 26,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardTitle(BuildContext context) => _style(
    size: 14,
    line: 18,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardBrand(BuildContext context) => _style(
    size: 14,
    line: 18,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle pdpPrice(BuildContext context) => _style(
    size: 24,
    line: 28,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.primary,
  );

  static TextStyle cardPrice(BuildContext context) => _style(
    size: 16,
    line: 20,
    weight: FontWeight.w600,
    color: DooryTokens.of(context).cardPrice,
  );

  static TextStyle compactPrice(BuildContext context) => _style(
    size: 16,
    line: 19,
    weight: FontWeight.w600,
    color: DooryTokens.of(context).cardPrice,
  );

  static TextStyle cta(BuildContext context) => _style(
    size: 18,
    line: 24,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  static TextStyle label(BuildContext context) => _style(
    size: 14,
    line: 20,
    weight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  static TextStyle labelStrong(BuildContext context) => _style(
    size: 14,
    line: 20,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardMeta(BuildContext context, {Color? color}) => _style(
    size: 12,
    line: 16,
    weight: FontWeight.w600,
    color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
  );

  static TextStyle shortcut(BuildContext context) => _style(
    size: 10,
    line: 13,
    weight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle navLabel(Color color) =>
      _style(size: 12, line: 16, weight: FontWeight.w600, color: color);
}
