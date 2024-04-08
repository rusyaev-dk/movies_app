part of '../theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color background;
  final Color onBackground;
  final Color surfaceDarker;

  ThemeColors({
    required this.surfaceDarker,
    required this.background,
    required this.onBackground,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? background,
    Color? onBackground,
    Color? surfaceDarker,
  }) {
    return ThemeColors(
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surfaceDarker: surfaceDarker ?? this.surfaceDarker,
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
    );
  }

  static get light => ThemeColors(
        background: AppColors.white,
        onBackground: AppColors.black,
        surfaceDarker: const Color(0xFF151515),
      );

  static get dark => ThemeColors(
        background: AppColors.black,
        onBackground: AppColors.white,
        surfaceDarker: const Color(0xFF151515),
      );
}
