import 'package:material_ui/material_ui.dart';

/// Hex tokens from DESIGN.md §1. Feature code reads [DooryTokens], not these.
abstract final class DooryColors {
  static const primary = Color(0xFFF27A1A);
  static const primaryStrong = Color(0xFFF27A1A);
  static const primaryHover = Color(0xFFD56B17);
  static const primarySubtle = Color(0xFFFFF3E8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF5F5F5);
  static const surfaceCanvas = Color(0xFFFAFAFA);
  static const surfaceInverse = Color(0xFF333333);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textOnStrong = Color(0xFFFFFFFF);
  static const border = Color(0xFFE6E6E6);
  static const borderControl = Color(0xFF858585);
  static const cardPrice = Color(0xFFC2410C);
  static const textMuted = Color(0xFF999999);
  static const discount = Color(0xFFBB0000);
  static const danger = Color(0xFFBB0000);
  static const success = Color(0xFF137333);
  static const successSurface = Color(0xFFE7F9EF);
  static const rating = Color(0xFFFFC000);
  static const previewPlus = Color(0xFFFF4988);
  static const shortcutBorder = Color(0xFFE9E9E9);
  static const footerBand = Color(0xFF1C1C1C);
  static const footerBandText = Color(0xFFBDBDBD);

  static const shortcutTeal = Color(0xFFDFF5F4);
  static const shortcutRose = Color(0xFFFDECEF);
  static const shortcutTerracotta = Color(0xFFFFF0E7);
  static const shortcutGreen = Color(0xFFE3F6E1);
  static const shortcutWine = Color(0xFFFDE8EF);
  static const shortcutCyan = Color(0xFFE1F4FA);

  static const tileTeal = Color(0xFF2B6E77);
  static const tileRose = Color(0xFF9A404A);
  static const tileTerracotta = Color(0xFF9A4C3D);
  static const tileGreen = Color(0xFF407C3D);
  static const tileWine = Color(0xFF982F49);
  static const tileCyan = Color(0xFF1F7B8E);
  static const tileViolet = Color(0xFF4A3D78);

  static const shadowCard = Color(0x14000000);
  static const shadowFavorite = Color(0x33000000);

  /// Sheet barrier. Black at 40% — the adopted default in p0-decisions §6.
  static const sheetBarrier = Color(0x66000000);
}
