import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/colors/app_color.dart';
import 'package:restaurant_app/styles/typography/app_text_style.dart';

class AppTheme {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: AppTextStyle.displayLarge,
      displayMedium: AppTextStyle.displayMedium,
      displaySmall: AppTextStyle.displaySmall,
      headlineLarge: AppTextStyle.headlineLarge,
      headlineMedium: AppTextStyle.headlineMedium,
      headlineSmall: AppTextStyle.headlineSmall,
      titleLarge: AppTextStyle.titleLarge,
      titleMedium: AppTextStyle.titleMedium,
      titleSmall: AppTextStyle.titleSmall,
      bodyLarge: AppTextStyle.bodyLargeBold,
      bodyMedium: AppTextStyle.bodyLargeMedium,
      bodySmall: AppTextStyle.bodyLargeRegular,
      labelLarge: AppTextStyle.labelLarge,
      labelMedium: AppTextStyle.labelMedium,
      labelSmall: AppTextStyle.labelSmall,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: AppColor.orange.color,
      textTheme: textTheme,
      brightness: Brightness.light,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: AppColor.orange.color,
      textTheme: textTheme,
      brightness: Brightness.dark,
    );
  }
}
