part of '../theme.dart';

ThemeData createLightTheme() {
  return ThemeData(
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.lightGrey,
    ),
    textTheme: createTextTheme(),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    hintColor: AppColors.grey,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.light,
      ThemeTextStyles.light,
      ThemeGradients.light,
    ],
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      primaryContainer: AppColors.orangeVariant,
      secondary: AppColors.grey,
      surface: AppColors.darkerGrey,
      error: AppColors.red,
      tertiary: AppColors.green,
      onTertiary: AppColors.white,
    ),
    focusColor: Colors.white.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
  );
}
