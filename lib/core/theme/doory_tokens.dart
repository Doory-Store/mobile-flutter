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
  final double s8 = 8;
  final double s12 = 12;
  final double s16 = 16;
  final double s20 = 20;
  final double s24 = 24;
  final double s32 = 32;
  final double gutter = 16;
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
    required this.previewPlus,
    required this.surfaceSubtle,
    required this.footerBand,
    required this.footerBandText,
    required this.shortcutPastels,
    required this.tileInks,
    required this.radiusCard,
    required this.radiusSearch,
    required this.radiusChip,
    required this.space,
  });

  final Color cardPrice;
  final Color rating;
  final Color textMuted;
  final Color primarySubtle;
  final Color primaryHover;
  final Color danger;
  final Color success;
  final Color previewPlus;
  final Color surfaceSubtle;
  final Color footerBand;
  final Color footerBandText;
  final ShortcutPastels shortcutPastels;
  final List<Color> tileInks;
  final double radiusCard;
  final double radiusSearch;
  final double radiusChip;
  final DoorySpacing space;

  static const light = DooryTokens(
    cardPrice: DooryColors.cardPrice,
    rating: DooryColors.rating,
    textMuted: DooryColors.textMuted,
    primarySubtle: DooryColors.primarySubtle,
    primaryHover: DooryColors.primaryHover,
    danger: DooryColors.danger,
    success: DooryColors.success,
    previewPlus: DooryColors.previewPlus,
    surfaceSubtle: DooryColors.surfaceSubtle,
    footerBand: DooryColors.footerBand,
    footerBandText: DooryColors.footerBandText,
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
    Color? previewPlus,
    Color? surfaceSubtle,
    Color? footerBand,
    Color? footerBandText,
    ShortcutPastels? shortcutPastels,
    List<Color>? tileInks,
    double? radiusCard,
    double? radiusSearch,
    double? radiusChip,
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
      previewPlus: previewPlus ?? this.previewPlus,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      footerBand: footerBand ?? this.footerBand,
      footerBandText: footerBandText ?? this.footerBandText,
      shortcutPastels: shortcutPastels ?? this.shortcutPastels,
      tileInks: tileInks ?? this.tileInks,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusSearch: radiusSearch ?? this.radiusSearch,
      radiusChip: radiusChip ?? this.radiusChip,
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
      previewPlus: Color.lerp(previewPlus, other.previewPlus, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      footerBand: Color.lerp(footerBand, other.footerBand, t)!,
      footerBandText: Color.lerp(footerBandText, other.footerBandText, t)!,
      shortcutPastels: t < 0.5 ? shortcutPastels : other.shortcutPastels,
      tileInks: t < 0.5 ? tileInks : other.tileInks,
      radiusCard: uiLerp(radiusCard, other.radiusCard, t)!,
      radiusSearch: uiLerp(radiusSearch, other.radiusSearch, t)!,
      radiusChip: uiLerp(radiusChip, other.radiusChip, t)!,
      space: t < 0.5 ? space : other.space,
    );
  }
}

double? uiLerp(num a, num b, double t) => a + (b - a) * t;
