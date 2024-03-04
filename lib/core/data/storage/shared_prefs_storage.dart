import 'package:movies_app/core/data/storage/db_interface.dart';
import 'package:movies_app/core/utils/service_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefsStorage implements DataBaseInterface {
  SharedPrefsStorage();

  late final SharedPreferences _prefs;

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<T?> get<T>(String key) async {
    Object? value;
    try {
      if (sameTypes<T, List<String>>()) {
        value = _prefs.getStringList(key);
      } else {
        value = _prefs.get(key);
      }

      // значения ещё нет в бд
      // if (value == null) {
      //   return defaultValue;
      // }

      return value as T;
    } catch (err, stackTrace) {
      // + реализовать logging...
      print("$err, ${stackTrace.toString()}");
      return null;
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

    throw Exception('Wrong type for saving to database');
  }

  @override
  Future<void> delete<T>(String key) async {
    try {
      await _prefs.remove(key);
    } catch (err, stackTrace) {
      // + реализовать logging...
      print("$err, ${stackTrace.toString()}");
    }
  }
}
