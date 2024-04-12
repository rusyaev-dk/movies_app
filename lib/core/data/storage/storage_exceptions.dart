enum StorageExceptionType { incorrectDataType, key, unknown }

abstract class StorageException implements Exception {
  final Object error;
  final String? message;
  const StorageException(this.error, {this.message});
}

class StorageDataTypeException extends StorageException {
  StorageDataTypeException(super.error, {super.message});
}

class StorageUnknownException extends StorageException {
  StorageUnknownException(super.error, {super.message});
}
