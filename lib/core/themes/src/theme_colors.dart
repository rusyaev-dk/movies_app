part of '../theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color background;
  final Color onBackground;
  final Color surfaceDarker;
  final Color activatedFilterButtonColor;
  final Color inActivatedFilterButtonColor;
  final Color activatedThemeButtonColor;
  final Color inActivatedThemeButtonColor;

  ThemeColors({
    required this.surfaceDarker,
    required this.background,
    required this.onBackground,
    required this.activatedFilterButtonColor,
    required this.inActivatedFilterButtonColor,
    required this.activatedThemeButtonColor,
    required this.inActivatedThemeButtonColor,
  });

  @override
  ThemeExtension<ThemeColors> copyWith(
      {Color? background,
      Color? onBackground,
      Color? surfaceDarker,
      Color? activatedFilterButtonColor,
      Color? inActivatedFilterButtonColor,
      Color? activatedThemeButtonColor,
      Color? inActivatedThemeButtonColor}) {
    return ThemeColors(
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surfaceDarker: surfaceDarker ?? this.surfaceDarker,
      activatedFilterButtonColor:
          activatedFilterButtonColor ?? this.activatedFilterButtonColor,
      inActivatedFilterButtonColor:
          inActivatedFilterButtonColor ?? this.inActivatedFilterButtonColor,
      activatedThemeButtonColor:
          activatedThemeButtonColor ?? this.activatedThemeButtonColor,
      inActivatedThemeButtonColor:
          inActivatedThemeButtonColor ?? this.inActivatedThemeButtonColor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surfaceDarker: Color.lerp(surfaceDarker, other.surfaceDarker, t)!,
      activatedFilterButtonColor: Color.lerp(
          activatedFilterButtonColor, other.activatedFilterButtonColor, t)!,
      inActivatedFilterButtonColor: Color.lerp(
          inActivatedFilterButtonColor, other.inActivatedFilterButtonColor, t)!,
      activatedThemeButtonColor: Color.lerp(
          activatedThemeButtonColor, other.activatedThemeButtonColor, t)!,
      inActivatedThemeButtonColor: Color.lerp(
          inActivatedThemeButtonColor, other.inActivatedThemeButtonColor, t)!,
    );
  }

  static get light => ThemeColors(
        background: AppColors.white,
        onBackground: AppColors.black,
        surfaceDarker: const Color(0xFFf5f6f6),
        activatedFilterButtonColor: const Color(0xFFb2b2b2),
        inActivatedFilterButtonColor: const Color(0xFFe0e0e2),
        activatedThemeButtonColor: AppColors.white,
        inActivatedThemeButtonColor: const Color(0xFFf5f6f6),
      );

  static get dark => ThemeColors(
        background: AppColors.black,
        onBackground: AppColors.white,
        surfaceDarker: const Color(0xFF151515),
        activatedFilterButtonColor: const Color(0xFF4d4d4d),
        inActivatedFilterButtonColor: const Color(0xFF151515),
        activatedThemeButtonColor: AppColors.black,
        inActivatedThemeButtonColor: const Color(0xFF151515),
      );
}
