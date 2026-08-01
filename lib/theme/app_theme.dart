import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //────────────────────────────────────────────────────────────
  // COLORS
  //────────────────────────────────────────────────────────────

  static const Color background = Color(0xFFF8F5EF);
  static const Color surface = Color(0xFFFFFCF8);

  static const Color primary = Color(0xFFE07A2F);
  static const Color primaryLight = Color(0xFFF2A96B);
  static const Color primaryDark = Color(0xFFC45E15);

  static const Color charcoal = Color(0xFF2D2A26);
  static const Color textSecondary = Color(0xFF6F6A63);
  static const Color textHint = Color(0xFFA7A19A);

  static const Color divider = Color(0xFFEAE3D9);

  static const Color success = Color(0xFF6D9773);
  static const Color error = Color(0xFFD35D47);
  static const Color warning = Color(0xFFE4A646);
  static const Color info = Color(0xFF6F9DB5);

  // Macro colors
  static const Color proteinColor = Color(0xFFB5654D);
  static const Color carbsColor = Color(0xFFD8A657);
  static const Color fatColor = Color(0xFF8A6A44);

  static const Color waterColor = Color(0xFF7DAFC2);
  static const Color caloriesColor = primary;

  //────────────────────────────────────────────────────────────
  // SPACING
  //────────────────────────────────────────────────────────────

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  //────────────────────────────────────────────────────────────
  // RADIUS
  //────────────────────────────────────────────────────────────

  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;
  static const double radiusFull = 100;

  //────────────────────────────────────────────────────────────
  // MOTION
  //────────────────────────────────────────────────────────────

  static const Duration fastAnimation = Duration(milliseconds: 150);

  static const Duration normalAnimation = Duration(milliseconds: 250);

  static const Duration slowAnimation = Duration(milliseconds: 400);

  //────────────────────────────────────────────────────────────
  // SHADOWS
  //────────────────────────────────────────────────────────────

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: .05),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: .035),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  //────────────────────────────────────────────────────────────
  // THEME
  //────────────────────────────────────────────────────────────

  static ThemeData get theme => ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primaryLight,
      surface: surface,
      error: error,
    ),

    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: charcoal,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: charcoal,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: charcoal,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: charcoal,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: charcoal,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: charcoal,
      ),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: charcoal),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: charcoal),
      bodySmall: GoogleFonts.poppins(fontSize: 12, color: textSecondary),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: background,
      centerTitle: false,
      iconTheme: IconThemeData(color: charcoal),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: primary,
      disabledColor: divider,
      padding: const EdgeInsets.symmetric(horizontal: md, vertical: sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusFull),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: divider,
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: charcoal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: GoogleFonts.poppins(color: textHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: md, vertical: md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: primary,
      thumbColor: primary,
      inactiveTrackColor: divider,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? primary
            : Colors.transparent,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primary),
      trackColor: WidgetStateProperty.all(primaryLight),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textHint,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
