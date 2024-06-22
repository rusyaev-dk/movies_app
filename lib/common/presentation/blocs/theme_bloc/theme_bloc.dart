import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/persistence/storage/storage_interface.dart';
import 'package:talker_flutter/talker_flutter.dart';

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

  static ThemeMode fromString(String? value) {
    if (value == null || value.isEmpty) {
      return ThemeMode.system;
    }

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

  late final KeyValueStorage _keyValueStorage;

  ThemeBloc({required KeyValueStorage keyValueStorage})
      : _keyValueStorage = keyValueStorage,
        super(const ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeRestoreThemeEvent>(_onRestoreTheme);
    on<ThemeToggleDarkThemeEvent>(_onToggleDarkTheme);
    on<ThemeToggleLightThemeEvent>(_onToggleLightTheme);
    on<ThemeToggleSystemThemeEvent>(_onToggleSystemTheme);
    add(ThemeRestoreThemeEvent());
  }

  Future<void> _onRestoreTheme(
    ThemeRestoreThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    ThemeMode themeMode;
    try {
      final String? themeModeStr =
          await _keyValueStorage.get<String>(key: themeModeKey);
      themeMode = ThemeModeX.fromString(themeModeStr);
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
      themeMode = ThemeMode.system;
    }

    emit(ThemeState(themeMode: themeMode));
    FlutterNativeSplash.remove();
  }

  Future<void> _onToggleDarkTheme(
    ThemeToggleDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _keyValueStorage.set<String>(
        key: themeModeKey,
        value: ThemeMode.dark.asString(),
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(const ThemeState(themeMode: ThemeMode.dark));
  }

  Future<void> _onToggleLightTheme(
    ThemeToggleLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _keyValueStorage.set<String>(
        key: themeModeKey,
        value: ThemeMode.light.asString(),
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(const ThemeState(themeMode: ThemeMode.light));
  }

  Future<void> _onToggleSystemTheme(
    ThemeToggleSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _keyValueStorage.set<String>(
        key: themeModeKey,
        value: ThemeMode.system.asString(),
      );
    } on StorageException catch (err, stackTrace) {
      GetIt.I<Talker>().handle(err, stackTrace);
    }

    emit(const ThemeState(themeMode: ThemeMode.system));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
