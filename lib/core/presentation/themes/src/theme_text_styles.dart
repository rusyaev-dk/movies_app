part of '../theme.dart';

class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  final TextStyle headingTextStyle;
  final TextStyle subtitleTextStyle;

  ThemeTextStyles({
    required this.headingTextStyle,
    required this.subtitleTextStyle,
  });

  @override
  ThemeExtension<ThemeTextStyles> copyWith({
    TextStyle? headingTextStyle,
    TextStyle? subtitleTextStyle,
  }) {
    return ThemeTextStyles(
      headingTextStyle: headingTextStyle ?? this.headingTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
    );
  }

  @override
  ThemeExtension<ThemeTextStyles> lerp(
    ThemeExtension<ThemeTextStyles>? other,
    double t,
  ) {
    if (other is! ThemeTextStyles) {
      return this;
    }

    return ThemeTextStyles(
      headingTextStyle:
          TextStyle.lerp(headingTextStyle, other.headingTextStyle, t)!,
      subtitleTextStyle:
          TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t)!,
    );
  }

  static get light => ThemeTextStyles(
        headingTextStyle: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        subtitleTextStyle: const TextStyle(
          color: AppColors.black,
          fontSize: 14,
        ),
      );

  static get dark => ThemeTextStyles(
        headingTextStyle: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        subtitleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
        ),
      );
}
