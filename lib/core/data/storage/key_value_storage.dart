import 'package:movies_app/core/data/storage/db_interface.dart';
import 'package:movies_app/core/data/storage/storage_exceptions.dart';
import 'package:movies_app/core/utils/service_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage implements DataBaseInterface {
  KeyValueStorage();

  late final SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
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
    } on TypeError catch (err, stackTrace) {
      Error.throwWithStackTrace(
        StorageDataTypeException(err, message: err.toString()),
        stackTrace,
      );
    } on Exception catch (err, stackTrace) {
      Error.throwWithStackTrace(
        StorageUnknownException(err, message: err.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<void> set<T>(String key, T value) {
    if (sameTypes<T, bool>()) {
      return _prefs.setBool(key, value as bool);
    }

    if (sameTypes<T, int>()) {
      return _prefs.setInt(key, value as int);
    }

    if (sameTypes<T, double>()) {
      return _prefs.setDouble(key, value as double);
    }

    if (sameTypes<T, String>()) {
      return _prefs.setString(key, value as String);
    }

    if (sameTypes<T, List<String>>()) {
      return _prefs.setStringList(key, value as List<String>);
    }

    if (value is Enum) {
      return _prefs.setInt(key, value.index);
    }

    Error.throwWithStackTrace(
      StorageDataTypeException(TypeError, message: TypeError().toString()),
      StackTrace.current,
    );
  }

  @override
  Future<void> delete<T>(String key) async {
    try {
      await _prefs.remove(key);
    } on TypeError catch (err, stackTrace) {
      Error.throwWithStackTrace(
        StorageDataTypeException(err, message: err.toString()),
        stackTrace,
      );
    } on Exception catch (err, stackTrace) {
      Error.throwWithStackTrace(
        StorageUnknownException(err, message: err.toString()),
        stackTrace,
      );
    }
  }
}
