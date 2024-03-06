part of '../theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    textTheme: createTextTheme(),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    hintColor: AppColors.grey,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.dark,
      // ThemeTextStyles.light,
      // ThemeGradients.light,
    ],
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      secondary: AppColors.darkestGrey,
      background: AppColors.black,
      onBackground: AppColors.white,
      error: AppColors.white
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.black,
      titleTextStyle: displayMedium.copyWith(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: displayMedium.copyWith(
        color: AppColors.white,
      ),
    ),
    focusColor: Colors.white.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
  );
}
