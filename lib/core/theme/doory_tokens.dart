import 'package:material_ui/material_ui.dart';

import 'doory_colors.dart';

@immutable
class ShortcutPastels {
  const ShortcutPastels({
    required this.teal,
    required this.rose,
    required this.terracotta,
    required this.green,
    required this.wine,
    required this.cyan,
    required this.border,
  });

  final Color teal;
  final Color rose;
  final Color terracotta;
  final Color green;
  final Color wine;
  final Color cyan;
  final Color border;

  List<Color> get cycle => [teal, rose, terracotta, green, wine, cyan];

  Color toneAt(int index) => cycle[index % cycle.length];
}

@immutable
class DoorySpacing {
  const DoorySpacing();

  final double s4 = 4;
  final double s6 = 6;
  final double s8 = 8;
  final double s12 = 12;
  final double s16 = 16;
  final double s20 = 20;
  final double s24 = 24;
  final double s32 = 32;
  final double s40 = 40;
  final double s48 = 48;
  final double gutter = 16;
  final double gutterDense = 8;
}

/// Icon boxes from the P0 scale. Directional chevrons flip; the rest do not.
abstract final class DooryIconSize {
  static const meta = 12.0;
  static const chevron = 16.0;
  static const inline = 20.0;
  static const chrome = 24.0;
  static const empty = 32.0;
}

/// Motion tokens. Shimmer stops when animations are disabled.
abstract final class DooryMotion {
  static const press = Duration(milliseconds: 100);
  static const fade = Duration(milliseconds: 200);
  static const sheet = Duration(milliseconds: 250);
  static const shimmer = Duration(milliseconds: 1200);
}

/// Shadows that are the exception to elevation 0.
abstract final class DooryShadows {
  static List<BoxShadow> favorite(Color color) => [
    BoxShadow(color: color, offset: const Offset(0, 2), blurRadius: 2),
  ];

  static List<BoxShadow> bar(Color color) => [
    BoxShadow(color: color, offset: const Offset(0, -2), blurRadius: 6),
  ];

  static List<BoxShadow> sheet(Color color) => [
    BoxShadow(color: color, offset: const Offset(0, -8), blurRadius: 24),
  ];
}

/// Hairline separator: a logical width of 0 paints one physical pixel.
abstract final class DooryBorders {
  static BorderSide hairline(Color color) => BorderSide(color: color, width: 0);
}

@immutable
class DooryTokens extends ThemeExtension<DooryTokens> {
  const DooryTokens({
    required this.cardPrice,
    required this.rating,
    required this.textMuted,
    required this.primarySubtle,
    required this.primaryHover,
    required this.danger,
    required this.success,
    required this.successSurface,
    required this.previewPlus,
    required this.surfaceSubtle,
    required this.surfaceCanvas,
    required this.footerBand,
    required this.footerBandText,
    required this.shadowCard,
    required this.shadowFavorite,
    required this.sheetBarrier,
    required this.shortcutPastels,
    required this.tileInks,
    required this.radiusCard,
    required this.radiusSearch,
    required this.radiusChip,
    required this.radius4,
    required this.radius6,
    required this.radius12,
    required this.radiusPill,
    required this.space,
  });

  final Color cardPrice;
  final Color rating;
  final Color textMuted;
  final Color primarySubtle;
  final Color primaryHover;
  final Color danger;
  final Color success;
  final Color successSurface;
  final Color previewPlus;
  final Color surfaceSubtle;
  final Color surfaceCanvas;
  final Color footerBand;
  final Color footerBandText;
  final Color shadowCard;
  final Color shadowFavorite;
  final Color sheetBarrier;
  final ShortcutPastels shortcutPastels;
  final List<Color> tileInks;
  final double radiusCard;
  final double radiusSearch;
  final double radiusChip;
  final double radius4;
  final double radius6;
  final double radius12;

  /// Full pill radius for callers that do not yet know the control height.
  final double radiusPill;
  final DoorySpacing space;

  static const light = DooryTokens(
    cardPrice: DooryColors.cardPrice,
    rating: DooryColors.rating,
    textMuted: DooryColors.textMuted,
    primarySubtle: DooryColors.primarySubtle,
    primaryHover: DooryColors.primaryHover,
    danger: DooryColors.danger,
    success: DooryColors.success,
    successSurface: DooryColors.successSurface,
    previewPlus: DooryColors.previewPlus,
    surfaceSubtle: DooryColors.surfaceSubtle,
    surfaceCanvas: DooryColors.surfaceCanvas,
    footerBand: DooryColors.footerBand,
    footerBandText: DooryColors.footerBandText,
    shadowCard: DooryColors.shadowCard,
    shadowFavorite: DooryColors.shadowFavorite,
    sheetBarrier: DooryColors.sheetBarrier,
    shortcutPastels: ShortcutPastels(
      teal: DooryColors.shortcutTeal,
      rose: DooryColors.shortcutRose,
      terracotta: DooryColors.shortcutTerracotta,
      green: DooryColors.shortcutGreen,
      wine: DooryColors.shortcutWine,
      cyan: DooryColors.shortcutCyan,
      border: DooryColors.shortcutBorder,
    ),
    tileInks: [
      DooryColors.tileTeal,
      DooryColors.tileRose,
      DooryColors.tileTerracotta,
      DooryColors.tileGreen,
      DooryColors.tileWine,
      DooryColors.tileCyan,
      DooryColors.tileViolet,
    ],
    radiusCard: 8,
    radiusSearch: 20,
    radiusChip: 4,
    radius4: 4,
    radius6: 6,
    radius12: 12,
    radiusPill: 999,
    space: DoorySpacing(),
  );

  static DooryTokens of(BuildContext context) {
    final tokens = Theme.of(context).extension<DooryTokens>();
    assert(tokens != null, 'DooryTokens is missing from the theme');
    return tokens ?? light;
  }

  @override
  DooryTokens copyWith({
    Color? cardPrice,
    Color? rating,
    Color? textMuted,
    Color? primarySubtle,
    Color? primaryHover,
    Color? danger,
    Color? success,
    Color? successSurface,
    Color? previewPlus,
    Color? surfaceSubtle,
    Color? surfaceCanvas,
    Color? footerBand,
    Color? footerBandText,
    Color? shadowCard,
    Color? shadowFavorite,
    Color? sheetBarrier,
    ShortcutPastels? shortcutPastels,
    List<Color>? tileInks,
    double? radiusCard,
    double? radiusSearch,
    double? radiusChip,
    double? radius4,
    double? radius6,
    double? radius12,
    double? radiusPill,
    DoorySpacing? space,
  }) {
    return DooryTokens(
      cardPrice: cardPrice ?? this.cardPrice,
      rating: rating ?? this.rating,
      textMuted: textMuted ?? this.textMuted,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      primaryHover: primaryHover ?? this.primaryHover,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      previewPlus: previewPlus ?? this.previewPlus,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceCanvas: surfaceCanvas ?? this.surfaceCanvas,
      footerBand: footerBand ?? this.footerBand,
      footerBandText: footerBandText ?? this.footerBandText,
      shadowCard: shadowCard ?? this.shadowCard,
      shadowFavorite: shadowFavorite ?? this.shadowFavorite,
      sheetBarrier: sheetBarrier ?? this.sheetBarrier,
      shortcutPastels: shortcutPastels ?? this.shortcutPastels,
      tileInks: tileInks ?? this.tileInks,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusSearch: radiusSearch ?? this.radiusSearch,
      radiusChip: radiusChip ?? this.radiusChip,
      radius4: radius4 ?? this.radius4,
      radius6: radius6 ?? this.radius6,
      radius12: radius12 ?? this.radius12,
      radiusPill: radiusPill ?? this.radiusPill,
      space: space ?? this.space,
    );
  }

  @override
  DooryTokens lerp(ThemeExtension<DooryTokens>? other, double t) {
    if (other is! DooryTokens) return this;
    return DooryTokens(
      cardPrice: Color.lerp(cardPrice, other.cardPrice, t)!,
      rating: Color.lerp(rating, other.rating, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      previewPlus: Color.lerp(previewPlus, other.previewPlus, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceCanvas: Color.lerp(surfaceCanvas, other.surfaceCanvas, t)!,
      footerBand: Color.lerp(footerBand, other.footerBand, t)!,
      footerBandText: Color.lerp(footerBandText, other.footerBandText, t)!,
      shadowCard: Color.lerp(shadowCard, other.shadowCard, t)!,
      shadowFavorite: Color.lerp(shadowFavorite, other.shadowFavorite, t)!,
      sheetBarrier: Color.lerp(sheetBarrier, other.sheetBarrier, t)!,
      shortcutPastels: t < 0.5 ? shortcutPastels : other.shortcutPastels,
      tileInks: t < 0.5 ? tileInks : other.tileInks,
      radiusCard: uiLerp(radiusCard, other.radiusCard, t)!,
      radiusSearch: uiLerp(radiusSearch, other.radiusSearch, t)!,
      radiusChip: uiLerp(radiusChip, other.radiusChip, t)!,
      radius4: uiLerp(radius4, other.radius4, t)!,
      radius6: uiLerp(radius6, other.radius6, t)!,
      radius12: uiLerp(radius12, other.radius12, t)!,
      radiusPill: uiLerp(radiusPill, other.radiusPill, t)!,
      space: t < 0.5 ? space : other.space,
    );
  }
}

double? uiLerp(num a, num b, double t) => a + (b - a) * t;
