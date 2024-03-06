part of '../theme.dart';

ThemeData createLightTheme() {
  return ThemeData(
    textTheme: createTextTheme(),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.light,
      // ThemeTextStyles.light,
      // ThemeGradients.light,
    ],
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      secondary: AppColors.lightGrey,
      background: AppColors.white,
      onBackground: AppColors.black,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.white,
      titleTextStyle: displayMedium.copyWith(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: displayMedium.copyWith(
        color: AppColors.black,
      ),
    ),
    focusColor: Colors.blue.withOpacity(0.2),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  );
}
