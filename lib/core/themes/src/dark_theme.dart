part of '../theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    textTheme: createTextTheme(),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    hintColor: AppColors.grey,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.dark,
      ThemeTextStyles.dark,
      ThemeGradients.dark,
    ],
    colorScheme: const ColorScheme.dark(
        primary: AppColors.orange,
        secondary: AppColors.darkestGrey,
        background: AppColors.black,
        onBackground: AppColors.white,
        surface: AppColors.grey,
        error: AppColors.white,
        tertiary: AppColors.green,
        onTertiary: AppColors.white),
    focusColor: Colors.white.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
  );
}
