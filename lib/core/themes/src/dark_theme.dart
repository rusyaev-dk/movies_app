part of '../theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.darkerGrey,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkerGrey,
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
      surface: AppColors.darkerGrey,
      error: AppColors.red,
      tertiary: AppColors.green,
      onTertiary: AppColors.white,
    ),
    focusColor: Colors.white.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
  );
}
