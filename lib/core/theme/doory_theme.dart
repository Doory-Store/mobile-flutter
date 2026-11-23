import 'package:material_ui/material_ui.dart';

import 'doory_colors.dart';
import 'doory_tokens.dart';
import 'doory_typography.dart';

ThemeData dooryTheme() {
  const tokens = DooryTokens.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: DooryColors.primary,
        brightness: Brightness.light,
        primary: DooryColors.primary,
        onPrimary: DooryColors.textOnStrong,
        secondary: DooryColors.textPrimary,
        onSecondary: DooryColors.textOnStrong,
        error: DooryColors.danger,
        onError: DooryColors.textOnStrong,
        surface: DooryColors.surface,
        onSurface: DooryColors.textPrimary,
      ).copyWith(
        primaryContainer: DooryColors.primarySubtle,
        onPrimaryContainer: DooryColors.primaryHover,
        onSurfaceVariant: DooryColors.textSecondary,
        outline: DooryColors.border,
        outlineVariant: DooryColors.borderControl,
        inverseSurface: DooryColors.footerBand,
        onInverseSurface: DooryColors.footerBandText,
        inversePrimary: DooryColors.primarySubtle,
        surfaceTint: Colors.transparent,
      );

  final textTheme =
      TextTheme(
        headlineSmall: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleLarge: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyLarge: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        bodyMedium: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 15,
          height: 22 / 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        labelLarge: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        labelSmall: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
        fontFamily: DooryTypography.family,
      );

  final buttonText = const TextStyle(
    fontFamily: DooryTypography.family,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: DooryTypography.family,
    fontFamilyFallback: const ['Tahoma', 'sans-serif'],
    scaffoldBackgroundColor: scheme.surface,
    splashColor: DooryColors.primarySubtle,
    highlightColor: DooryColors.primarySubtle,
    textTheme: textTheme,
    extensions: const [tokens],
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        side: BorderSide(color: scheme.outline),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerColor: scheme.outline,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DooryColors.surfaceSubtle,
      hintStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusSearch),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusSearch),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusSearch),
        borderSide: const BorderSide(
          color: DooryColors.primaryStrong,
          width: 2,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return DooryColors.border;
          if (states.contains(WidgetState.pressed)) {
            return DooryColors.primaryHover;
          }
          return DooryColors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return DooryColors.textSecondary;
          }
          return DooryColors.textOnStrong;
        }),
        textStyle: WidgetStatePropertyAll(buttonText),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        overlayColor: const WidgetStatePropertyAll(Color(0x14FFFFFF)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
        foregroundColor: const WidgetStatePropertyAll(
          DooryColors.primaryStrong,
        ),
        textStyle: WidgetStatePropertyAll(buttonText),
        side: const WidgetStatePropertyAll(
          BorderSide(color: DooryColors.primaryStrong, width: 2),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DooryColors.primaryHover,
        textStyle: const TextStyle(
          fontFamily: DooryTypography.family,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        minimumSize: const Size(48, 44),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: scheme.onSurface,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 56,
      elevation: 0,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return DooryTypography.tabLabel(
          selected ? DooryColors.primary : DooryColors.textPrimary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? DooryColors.primary : DooryColors.textPrimary,
          size: 24,
        );
      }),
      overlayColor: const WidgetStatePropertyAll(DooryColors.primarySubtle),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: DooryColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: DooryColors.primary,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surface,
      selectedColor: DooryColors.primarySubtle,
      side: BorderSide(color: scheme.outline),
      labelStyle: const TextStyle(
        fontFamily: DooryTypography.family,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: DooryColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: const StadiumBorder(),
    ),
  );
}
