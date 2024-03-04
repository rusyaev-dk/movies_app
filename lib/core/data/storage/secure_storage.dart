import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movies_app/core/data/storage/db_interface.dart';
import 'package:movies_app/core/utils/service_functions.dart';


class SecureStorage implements DataBaseInterface {
  static const _secureStorage = FlutterSecureStorage();

  @override
  Future<void> init() async {
    throw UnimplementedError(
        "init() method is not implemented for SecureStorage");
  }

  @override
  Future<T?> get<T>(String key) async {
    Object? value;
    try {
      value = await _secureStorage.read(key: key);
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
      throw Exception('Wrong type for saving to database');
    }

    if (sameTypes<T, int>()) {
      return _secureStorage.write(
        key: key,
        value: (value as int).toString(),
      );
    }

    if (sameTypes<T, double>()) {
      return _secureStorage.write(
        key: key,
        value: (value as double).toString(),
      );
    }

    if (sameTypes<T, String>()) {
      return _secureStorage.write(key: key, value: value as String);
    }

    if (sameTypes<T, List<String>>()) {
      throw Exception('Wrong type for saving to database');
    }

    if (value is Enum) {
      throw Exception('Wrong type for saving to database');
    }

    throw Exception('Wrong type for saving to database');
  }

  @override
  Future<void> delete<T>(String key) async {
    try {
      _secureStorage.delete(key: key);
    } catch (err, stackTrace) {
      // + реализовать logging...
      print("$err, ${stackTrace.toString()}");
    }
  }
}
