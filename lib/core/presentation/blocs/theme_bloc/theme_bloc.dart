import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.dark)) {
    on<ThemeToggleDarkThemeEvent>(_onToggleDarkTheme);
    on<ThemeToggleLightThemeEvent>(_onToggleLightTheme);
    on<ThemeToggleSystemThemeEvent>(_onToggleSystemTheme);
  }

  void _onToggleDarkTheme(
    ThemeToggleDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  void _onToggleLightTheme(
    ThemeToggleLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  void _onToggleSystemTheme(
    ThemeToggleSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(themeMode: ThemeMode.system));
  }
}
