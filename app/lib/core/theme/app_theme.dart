import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette shared with the static resume site (web/styles.css), kept
/// in sync by hand so web/ and app/ read as one portfolio brand.
class AppColors {
  AppColors._();

  static const primaryLight = Color(0xFF667EEA);
  static const primaryDarkAccentLight = Color(0xFF764BA2); // gradient end, light mode
  static const accentLight = Color(0xFFF093FB);
  static const textPrimaryLight = Color(0xFF2C3E50);
  static const textSecondaryLight = Color(0xFF7F8C8D);
  static const bgPrimaryLight = Color(0xFFFFFFFF);
  static const bgSecondaryLight = Color(0xFFF8F9FA);

  static const primaryDark = Color(0xFF818CF8);
  static const primaryDarkAccentDark = Color(0xFF9333EA); // gradient end, dark mode
  static const accentDark = Color(0xFFFB7185);
  static const textPrimaryDark = Color(0xFFE5E7EB);
  static const textSecondaryDark = Color(0xFF9CA3AF);
  static const bgPrimaryDark = Color(0xFF1F2937);
  static const bgSecondaryDark = Color(0xFF111827);

  static const heroGradientLight = [primaryLight, primaryDarkAccentLight];
  static const heroGradientDark = [primaryDark, primaryDarkAccentDark];
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryLight,
          onPrimary: Colors.white,
          secondary: AppColors.accentLight,
          onSecondary: AppColors.textPrimaryLight,
          surface: AppColors.bgPrimaryLight,
          onSurface: AppColors.textPrimaryLight,
          surfaceContainerHighest: AppColors.bgSecondaryLight,
          onSurfaceVariant: AppColors.textSecondaryLight,
        ),
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryDark,
          onPrimary: Colors.black,
          secondary: AppColors.accentDark,
          onSecondary: AppColors.textPrimaryDark,
          surface: AppColors.bgPrimaryDark,
          onSurface: AppColors.textPrimaryDark,
          surfaceContainerHighest: AppColors.bgSecondaryDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
        ),
      );

  static ThemeData _build({required Brightness brightness, required ColorScheme colorScheme}) {
    final base = ThemeData(brightness: brightness, colorScheme: colorScheme, useMaterial3: true);
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: colorScheme.primary, fontWeight: FontWeight.w600),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
      ),
    );
  }
}
