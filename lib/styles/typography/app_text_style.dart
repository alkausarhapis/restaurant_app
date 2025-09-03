import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static final TextStyle _sans = GoogleFonts.plusJakartaSans();
  static final TextStyle _serif = GoogleFonts.playfairDisplay();

  /// displayLarge Text Style
  static TextStyle displayLarge = _serif.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.11,
  );

  /// displayMedium Text Style
  static TextStyle displayMedium = _serif.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.17,
  );

  /// displaySmall Text Style
  static TextStyle displaySmall = _serif.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );

  /// headlineLarge Text Style
  static TextStyle headlineLarge = _serif.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// headlineMedium Text Style
  static TextStyle headlineMedium = _serif.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// headlineMedium Text Style
  static TextStyle headlineSmall = _serif.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -1,
  );

  /// titleLarge Text Style
  static TextStyle titleLarge = _sans.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// titleMedium Text Style
  static TextStyle titleMedium = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// titleSmall Text Style
  static TextStyle titleSmall = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
  );

  /// bodyLargeBold Text Style
  static TextStyle bodyLargeBold = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// bodyLargeMedium Text Style
  static TextStyle bodyLargeMedium = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  /// bodyLargeRegular Text Style
  static TextStyle bodyLargeRegular = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w200,
  );

  /// labelLarge Text Style
  static TextStyle labelLarge = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.71,
  );

  /// labelMedium Text Style
  static TextStyle labelMedium = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w200,
    height: 1.4,
  );

  /// labelSmall Text Style
  static TextStyle labelSmall = _sans.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w100,
    height: 1.2,
  );
}
