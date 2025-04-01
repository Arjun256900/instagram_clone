import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_text_style.dart';
import 'app_colors.dart';

class AppTheme {
  // Light mode
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.primary,
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.body,
      titleLarge: AppTextStyles.title,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: AppTextStyles.title,
      iconTheme: IconThemeData(
        color: AppColors.secondary,
      ), // Dark logo text for light mode
    ),
  );

  // Dark mode
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkPrimary,
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.body,
      titleLarge: AppTextStyles.title,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      titleTextStyle: AppTextStyles.title,
      iconTheme: IconThemeData(color: AppColors.darkSecondary),   // Light logo text in dark background
    ),
  );
}
