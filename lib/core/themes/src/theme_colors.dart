part of '../theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color filterButtonFillColor;

  const ThemeColors({
    required this.filterButtonFillColor,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? filterButtonFillColor,
  }) {
    return ThemeColors(
      filterButtonFillColor:
          filterButtonFillColor ?? this.filterButtonFillColor,
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
      filterButtonFillColor:
          Color.lerp(filterButtonFillColor, other.filterButtonFillColor, t)!,
    );
  }

  static get light => const ThemeColors(
        filterButtonFillColor: AppColors.grey,
      );

  static get dark => const ThemeColors(
        filterButtonFillColor: AppColors.white,
      );
}
