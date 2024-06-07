part of '../theme.dart';

class ThemeGradients extends ThemeExtension<ThemeGradients> {
  final Gradient shimmerGradient;

  const ThemeGradients({
    required this.shimmerGradient,
  });

  @override
  ThemeExtension<ThemeGradients> copyWith({
    Gradient? shimmerGradient,
  }) {
    return ThemeGradients(
      shimmerGradient: shimmerGradient ?? this.shimmerGradient,
    );
  }

  @override
  ThemeExtension<ThemeGradients> lerp(
    ThemeExtension<ThemeGradients>? other,
    double t,
  ) {
    if (other is! ThemeGradients) {
      return this;
    }

    return ThemeGradients(
      shimmerGradient:
          Gradient.lerp(shimmerGradient, other.shimmerGradient, t)!,
    );
  }

  static get light => const ThemeGradients(
        shimmerGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFa7a7a7),
            Color(0xFFa7a7a7),
            Color(0xFFc7c7c7),
            Color(0xFFa7a7a7),
            Color(0xFFa7a7a7),
          ],
          stops: <double>[0.0, 0.35, 0.5, 0.65, 1.0],
        ),
      );

  static get dark => ThemeGradients(
        shimmerGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade900,
            Colors.grey.shade700,
            Colors.grey.shade900,
            Colors.grey.shade900,
          ],
          stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
        ),
      );
}
