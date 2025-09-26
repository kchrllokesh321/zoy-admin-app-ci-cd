import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppThemeHelper {
  // ===========================
  // COMMON TEXT THEME
  // ===========================

  static TextTheme _buildTextTheme({required Color bodyColor, required Color displayColor}) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(color: displayColor, fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: GoogleFonts.outfit(color: displayColor, fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: GoogleFonts.outfit(color: displayColor, fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: GoogleFonts.outfit(color: bodyColor, fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.outfit(color: bodyColor, fontSize: 28, fontWeight: FontWeight.w400),
      headlineSmall: GoogleFonts.outfit(color: bodyColor, fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.outfit(color: bodyColor, fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.outfit(color: bodyColor, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: GoogleFonts.outfit(color: bodyColor, fontSize: 14, fontWeight: FontWeight.w400),
      bodyLarge: GoogleFonts.outfit(color: bodyColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.outfit(color: bodyColor, fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.outfit(color: bodyColor, fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.outfit(color: bodyColor, fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.outfit(color: bodyColor, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.outfit(color: bodyColor, fontSize: 11, fontWeight: FontWeight.w500),
    ).apply(bodyColor: bodyColor, displayColor: displayColor);
  }

  // =============================================================================
  // LIGHT THEME
  // =============================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: const Color(0xff424AF3),
        error: const Color(0xffFF5D5F),
        onError: const Color(0xffFF5D5F),
      ),
      scaffoldBackgroundColor: Color(0xffFAF9FA),
      brightness: Brightness.light,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textTheme: _buildTextTheme(bodyColor: const Color(0xff0A0A0C), displayColor: const Color(0xff0A0A0C)),
      radioTheme: RadioThemeData(
        fillColor: WidgetStatePropertyAll(Color(0xff424AF3)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xffFFFFFF),
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2E2E2E)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xffFF5D5F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
        ),
        errorMaxLines: 2,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xff4E55F4), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffFF5D5F), width: 1.5),
        ),
        fillColor: const Color(0xffFFFFFF),
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: const Color(0xffB5B7F8),
          backgroundColor: const Color(0xff4E55F4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Color(0xff5C5C5C);
        }),
        side: BorderSide(color: Color(0xff5C5C5C), width: 2),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xff4E55F4);
          }
          return Colors.white;
        }),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFEBF3FC)),
        dataRowColor: WidgetStateProperty.all(Colors.white),
        dividerThickness: 0.4,
        columnSpacing: 5,
        horizontalMargin: 24,
        headingRowHeight: 53,
        dataRowMinHeight: 76,
        dataRowMaxHeight: 76,
        headingTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF000000)),
        dataTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF000000)),
      ),
      hoverColor: Colors.transparent,
    );
  }

  // =============================================================================
  // DARK THEME
  // =============================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: const Color(0xff424AF3),
        error: const Color(0xffFF5D5F),
        onError: const Color(0xffFF5D5F),
      ),
      scaffoldBackgroundColor: Color(0xff121212),
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textTheme: _buildTextTheme(bodyColor: const Color(0xffFFFFFF), displayColor: const Color(0xffFFFFFF)),
      radioTheme: RadioThemeData(
        fillColor: WidgetStatePropertyAll(Color(0xff4E55F4)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xff121212),
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffFFFFFF)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffD4D7E3), width: 1.5),
        ),
        errorMaxLines: 2,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xff4E55F4), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xffFF5D5F), width: 1.5),
        ),
        fillColor: const Color(0xffFFFFFF),
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: const Color(0xffB5B7F8),
          backgroundColor: const Color(0xff4E55F4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Color(0xff5C5C5C);
        }),
        side: BorderSide(color: Color(0xff5C5C5C), width: 2),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xff4E55F4);
          }
          return Colors.white;
        }),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFEBF3FC)),
        dataRowColor: WidgetStateProperty.all(Colors.white),
        dividerThickness: 0.4,
        columnSpacing: 5,

        horizontalMargin: 24,
        headingRowHeight: 53,
        dataRowMinHeight: 76,
        dataRowMaxHeight: 76,
        headingTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF000000)),
        dataTextStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF000000)),
      ),
      hoverColor: Colors.transparent,
    );
  }
}
