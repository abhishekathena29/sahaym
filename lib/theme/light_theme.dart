import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

ThemeData getLightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.lightSurface,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24.sp, // Adjusted size
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 20.sp, // Adjusted size
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        // Added titleLarge for form titles
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        // Added bodySmall for smaller form elements
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
