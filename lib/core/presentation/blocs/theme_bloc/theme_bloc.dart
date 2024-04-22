import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

part 'theme_event.dart';
part 'theme_state.dart';

extension ThemeModeX on ThemeMode {
  String asString() {
    switch (this) {
      case ThemeMode.system:
        return "system";
      case ThemeMode.dark:
        return "dark";
      case ThemeMode.light:
        return "light";
    }
  }

  static ThemeMode fromString(String value) {
    switch (value) {
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const themeModeKey = "theme_mode";

  late final KeyValueStorageRepository _keyValueStorageRepository;

  ThemeBloc({required KeyValueStorageRepository keyValueStorageRepository})
      : _keyValueStorageRepository = keyValueStorageRepository,
        super(ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeRestoreThemeEvent>(_onRestoreTheme);
    on<ThemeToggleDarkThemeEvent>(_onToggleDarkTheme);
    on<ThemeToggleLightThemeEvent>(_onToggleLightTheme);
    on<ThemeToggleSystemThemeEvent>(_onToggleSystemTheme);
  }

  Future<void> _onRestoreTheme(
    ThemeRestoreThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final KeyValueStorageRepositoryPattern keyValueStorageRepoPattern =
        await _keyValueStorageRepository.get<String>(key: themeModeKey);

    ThemeMode? themeMode;
    switch (keyValueStorageRepoPattern) {
      case (final StorageRepositoryFailure _, null):
        themeMode = ThemeMode.system;
        break;
      case (null, final String resThemeMode):
        themeMode = ThemeModeX.fromString(resThemeMode);
    }
    emit(ThemeState(themeMode: themeMode!));
    FlutterNativeSplash.remove();
  }

  Future<void> _onToggleDarkTheme(
    ThemeToggleDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _keyValueStorageRepository.set<String>(
      key: themeModeKey,
      value: ThemeMode.dark.asString(),
    );

    emit(ThemeState(themeMode: ThemeMode.dark));
  }

  Future<void> _onToggleLightTheme(
    ThemeToggleLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _keyValueStorageRepository.set<String>(
      key: themeModeKey,
      value: ThemeMode.light.asString(),
    );
    emit(ThemeState(themeMode: ThemeMode.light));
  }

  Future<void> _onToggleSystemTheme(
    ThemeToggleSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _keyValueStorageRepository.set<String>(
      key: themeModeKey,
      value: ThemeMode.system.asString(),
    );
    emit(ThemeState(themeMode: ThemeMode.system));
  }
}
