import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/persistence/storage/storage_interface.dart';
import 'package:movies_app/core/utils/service_functions.dart';

class SecureStorage implements KeyValueStorage {
  SecureStorage({required FlutterSecureStorage storage}) : _secureStorage = storage;
  
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> init() async {
    throw UnimplementedError(
      "init() method is not implemented for SecureStorage",
    );
  }

  @override
  Future<T?> get<T>({required String key}) async {
    Object? value;
    try {
      value = await _secureStorage.read(key: key);
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
  Future<void> set<T>({required String key, required T value}) async {
    if (sameTypes<T, bool>()) {
      throw Exception('Wrong type for saving to database');
    }

    if (sameTypes<T, int>()) {
      return await _secureStorage.write(
        key: key,
        value: (value as int).toString(),
      );
    }

    if (sameTypes<T, double>()) {
      return await _secureStorage.write(
        key: key,
        value: (value as double).toString(),
      );
    }

    if (sameTypes<T, String>()) {
      return await _secureStorage.write(key: key, value: value as String);
    }

    if (sameTypes<T, List<String>>()) {
      Error.throwWithStackTrace(
        StorageDataTypeException(TypeError,
            message: "List of strings is not supported for Secure storage"),
        StackTrace.current,
      );
    }

    if (value is Enum) {
      Error.throwWithStackTrace(
        StorageDataTypeException(TypeError,
            message: "Enum of strings is not supported for Secure storage"),
        StackTrace.current,
      );
    }

    Error.throwWithStackTrace(
      StorageDataTypeException(TypeError, message: TypeError().toString()),
      StackTrace.current,
    );
  }

  @override
  Future<void> delete<T>({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
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
