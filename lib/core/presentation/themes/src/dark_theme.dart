part of '../theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.darkestGrey,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkestGrey,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: AppColors.grey,
    ),
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
      primaryContainer: AppColors.orangeVariant,
      secondary: AppColors.grey,
      surface: AppColors.darkestGrey,
      error: AppColors.red,
      tertiary: AppColors.green,
      onTertiary: AppColors.white,
    ),
    focusColor: Colors.white.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
  );
}
