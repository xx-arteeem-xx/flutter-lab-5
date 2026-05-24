import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _dark();
  static ThemeData get light => _light();

  // ─────────────────────────────────────── DARK ────────────────────────────

  static ThemeData _dark() {
    const cs = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: Color(0xFF001F2E),
      primaryContainer: Color(0xFF00344A),
      secondary: Color(0xFF8892B0),
      onSecondary: AppColors.darkBg,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkBodyText,
      error: AppColors.danger,
      outline: AppColors.darkBorder,
    );

    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.darkBg,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(
            color: AppColors.darkHeading, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.nunito(
            color: AppColors.darkHeading, fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.nunito(
            color: AppColors.darkHeading, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.nunito(
            color: AppColors.darkHeading, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.nunito(
            color: AppColors.darkHeading, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.nunito(
            color: AppColors.darkBodyText, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.nunito(
            color: AppColors.darkBodyText, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.nunito(
            color: AppColors.darkBodyText, fontWeight: FontWeight.w500),
        bodyLarge:
            GoogleFonts.nunito(color: AppColors.darkBodyText, fontSize: 16),
        bodyMedium:
            GoogleFonts.nunito(color: AppColors.darkBodyText, fontSize: 14),
        bodySmall: GoogleFonts.nunito(
            color: AppColors.darkMuted, fontSize: 12),
        labelLarge: GoogleFonts.nunito(
            color: AppColors.darkBodyText,
            fontWeight: FontWeight.w600,
            fontSize: 14),
        labelMedium: GoogleFonts.nunito(
            color: AppColors.darkMuted,
            fontSize: 12,
            letterSpacing: 0.5),
        labelSmall: GoogleFonts.nunito(
            color: AppColors.darkMuted,
            fontSize: 11,
            letterSpacing: 0.8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.nunito(
          color: AppColors.darkBodyText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkBodyText),
        actionsIconTheme: const IconThemeData(color: AppColors.accent),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBarDark,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Color(0xFF8892B0),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkGlass,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accent.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.nunito(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide(color: AppColors.accent.withValues(alpha: 0.4)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.accent),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.accent,
        textColor: AppColors.darkBodyText,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return const Color(0xFF8892B0);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent.withValues(alpha: 0.3);
          }
          return const Color(0xFF8892B0).withValues(alpha: 0.2);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accent.withValues(alpha: 0.12),
        inactiveTrackColor: AppColors.accent.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.accent,
        valueIndicatorTextStyle:
            GoogleFonts.nunito(color: const Color(0xFF001F2E), fontWeight: FontWeight.w600),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: Color(0x1A50C8FF),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF162033),
        contentTextStyle:
            GoogleFonts.nunito(color: AppColors.darkBodyText, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: const Color(0xFF001F2E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle:
              GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle:
              GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Color(0xFF001F2E),
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // ─────────────────────────────────────── LIGHT ───────────────────────────

  static ThemeData _light() {
    const cs = ColorScheme.light(
      primary: AppColors.accentLight,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD5E3FF),
      secondary: Color(0xFF5B6E9D),
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightBodyText,
      error: Color(0xFFB00020),
      outline: AppColors.lightBorder,
    );

    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.lightBg,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(
            color: AppColors.lightHeading, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.nunito(
            color: AppColors.lightHeading, fontWeight: FontWeight.w700),
        headlineLarge: GoogleFonts.nunito(
            color: AppColors.lightHeading, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.nunito(
            color: AppColors.lightHeading, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.nunito(
            color: AppColors.lightHeading, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.nunito(
            color: AppColors.lightBodyText, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.nunito(
            color: AppColors.lightBodyText, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.nunito(
            color: AppColors.lightBodyText, fontWeight: FontWeight.w500),
        bodyLarge:
            GoogleFonts.nunito(color: AppColors.lightBodyText, fontSize: 16),
        bodyMedium:
            GoogleFonts.nunito(color: AppColors.lightBodyText, fontSize: 14),
        bodySmall:
            GoogleFonts.nunito(color: AppColors.lightMuted, fontSize: 12),
        labelLarge: GoogleFonts.nunito(
            color: AppColors.lightBodyText,
            fontWeight: FontWeight.w600,
            fontSize: 14),
        labelMedium: GoogleFonts.nunito(
            color: AppColors.lightMuted, fontSize: 12, letterSpacing: 0.5),
        labelSmall: GoogleFonts.nunito(
            color: AppColors.lightMuted, fontSize: 11, letterSpacing: 0.8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.nunito(
          color: AppColors.lightBodyText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightBodyText),
        actionsIconTheme: const IconThemeData(color: AppColors.accentLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.accentLight,
        unselectedItemColor: Color(0xFF8892B0),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.accentLight.withValues(alpha: 0.10),
        labelStyle: GoogleFonts.nunito(
          color: AppColors.accentLight,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide(color: AppColors.accentLight.withValues(alpha: 0.3)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.accentLight),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.accentLight,
        textColor: AppColors.lightBodyText,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentLight;
          }
          return const Color(0xFF8892B0);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentLight.withValues(alpha: 0.3);
          }
          return const Color(0xFF8892B0).withValues(alpha: 0.2);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accentLight,
        thumbColor: AppColors.accentLight,
        overlayColor: AppColors.accentLight.withValues(alpha: 0.12),
        inactiveTrackColor: AppColors.accentLight.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.accentLight,
        valueIndicatorTextStyle: GoogleFonts.nunito(
            color: Colors.white, fontWeight: FontWeight.w600),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentLight,
        linearTrackColor: Color(0x1A173EAC),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle:
            GoogleFonts.nunito(color: AppColors.lightBodyText, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentLight,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle:
              GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentLight,
          side: const BorderSide(color: AppColors.accentLight, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle:
              GoogleFonts.nunito(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
