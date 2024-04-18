import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/data/storage/db_interface.dart';
import 'package:movies_app/core/utils/service_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage implements DataBaseInterface {
  KeyValueStorage();

  late final SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // await _prefs.clear();
  }

  @override
  Future<T?> get<T>(String key) async {
    Object? value;
    try {
      if (sameTypes<T, List<String>>()) {
        value = _prefs.getStringList(key);
      } else {
        value = _prefs.get(key);
      }

      return value as T;
    } on TypeError catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        StorageDataTypeException(exception, message: exception.toString()),
        stackTrace,
      );
    } on Exception catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        StorageUnknownException(exception, message: exception.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    if (sameTypes<T, bool>()) {
      return await _prefs.setBool(key, value as bool);
    }

    if (sameTypes<T, int>()) {
      return await _prefs.setInt(key, value as int);
    }

    if (sameTypes<T, double>()) {
      return await _prefs.setDouble(key, value as double);
    }

    if (sameTypes<T, String>()) {
      return await _prefs.setString(key, value as String);
    }

    if (sameTypes<T, List<String>>()) {
      return await _prefs.setStringList(key, value as List<String>);
    }

    if (value is Enum) {
      return await _prefs.setInt(key, value.index);
    }

    Error.throwWithStackTrace(
      StorageDataTypeException(TypeError, message: TypeError().toString()),
      StackTrace.current,
    );
  }

  @override
  Future<bool> delete<T>(String key) async {
    try {
      return await _prefs.remove(key);
    } on TypeError catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        StorageDataTypeException(exception, message: exception.toString()),
        stackTrace,
      );
    } on Exception catch (exception, stackTrace) {
      Error.throwWithStackTrace(
        StorageUnknownException(exception, message: exception.toString()),
        stackTrace,
      );
    }
  }
}
