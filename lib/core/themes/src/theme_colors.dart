part of '../theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color surfaceDarker;

  ThemeColors({required this.surfaceDarker});

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? surfaceDarker,
  }) {
    return ThemeColors(
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
      surfaceDarker: Color.lerp(surfaceDarker, other.surfaceDarker, t)!,
    );
  }

  static get light => ThemeColors(
        surfaceDarker: const Color(0xFF1D1D1D).withAlpha(140),
      );

  static get dark => ThemeColors(
        surfaceDarker: const Color(0xFF1D1D1D).withAlpha(140),
      );
}
