import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // --- App Colors ---
  static const Color primary = Color(0xFF4A4E9D);
  static const Color secondary = Color(0xFFE6E7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color lightGray = Color(0xFFF0F2F5);
  static const Color red = Colors.red;
  static const Color green = Colors.green;

  // --- Main Theme Data ---
  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: lightGray,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
        error: red,
        background: lightGray,
      ),
      textTheme: GoogleFonts.cairoTextTheme(_textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0.5,
        shadowColor: Colors.grey.withOpacity(0.2),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: GoogleFonts.cairo(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.cairo(
          color: textSecondary.withOpacity(0.7),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero,
      ));

  // --- Text Theme (using Cairo from Google Fonts) ---
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.cairo(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: textPrimary,
        letterSpacing: -1.5),
    displayMedium: GoogleFonts.cairo(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: -0.5),
    displaySmall: GoogleFonts.cairo(
        fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),

    headlineLarge: GoogleFonts.cairo(
        fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary),
    headlineMedium: GoogleFonts.cairo(
        fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
    headlineSmall: GoogleFonts.cairo(
        fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),

    titleLarge: GoogleFonts.cairo(
        fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
    titleMedium: GoogleFonts.cairo(
        fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
    titleSmall: GoogleFonts.cairo(
        fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),

    bodyLarge: GoogleFonts.cairo(fontSize: 16, color: textPrimary),
    bodyMedium: GoogleFonts.cairo(fontSize: 14, color: textSecondary),
    bodySmall: GoogleFonts.cairo(fontSize: 12, color: textSecondary),

    labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white), // For buttons
    labelMedium: GoogleFonts.cairo(fontSize: 12, color: textSecondary),
    labelSmall: GoogleFonts.cairo(fontSize: 10, color: textSecondary),
  );
}
