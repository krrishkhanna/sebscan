import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color kColorPrimary = Color(0xFF2d6a4f);
  static const Color kColorSecondary = Color(0xFFd4a017);
  static const Color kColorScaffold = Color(0xFFf8f5f0);
  static const Color kColorBorder = Color(0xFFe5e7eb);
  static const Color kColorWhite = Colors.white;
  static const Color kColorTextPrimary = Color(0xFF111827);
  static const Color kColorOverlay = Color(0xFF000000);
  static const Color kColorDanger = Color(0xFFdc2626);
  static const Color kColorWarning = Color(0xFFf59e0b);
  static const Color kColorSafe = Color(0xFF16a34a);
  static const Color kColorMuted = Color(0xFF6b7280);
  static const Color kColorSeverityHigh = Color(0xFFdc2626);
  static const Color kColorSeverityMed = Color(0xFFf59e0b);
  static const Color kColorSeverityLow = Color(0xFF9ca3af);

  static const Color kCategoryGutBg = Color(0xFFfef3c7);
  static const Color kCategoryGutText = Color(0xFFd97706);
  static const Color kCategoryInflammatoryBg = Color(0xFFfee2e2);
  static const Color kCategoryInflammatoryText = Color(0xFFdc2626);
  static const Color kCategoryHormonalBg = Color(0xFFede9fe);
  static const Color kCategoryHormonalText = Color(0xFF7c3aed);
  static const Color kCategoryYeastBg = Color(0xFFfef9c3);
  static const Color kCategoryYeastText = Color(0xFFca8a04);

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      primaryColor: kColorPrimary,
      scaffoldBackgroundColor: kColorScaffold,
      colorScheme: const ColorScheme.light(
        primary: kColorPrimary,
        secondary: kColorSecondary,
      ),
      cardTheme: CardTheme(
        color: kColorWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kColorBorder),
        ),
      ),
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: kColorTextPrimary,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: kColorTextPrimary,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          color: kColorTextPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          color: kColorTextPrimary,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 13,
          color: kColorMuted,
        ),
        labelMedium: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: kColorTextPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kColorScaffold,
        foregroundColor: kColorTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: kColorTextPrimary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: kColorPrimary,
        contentTextStyle: GoogleFonts.dmSans(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kColorWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kColorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kColorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kColorPrimary),
        ),
      ),
    );
  }
}
