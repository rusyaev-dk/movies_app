part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {}

final class ThemeRestoreThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

final class ThemeToggleDarkThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

final class ThemeToggleLightThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

final class ThemeToggleSystemThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}
