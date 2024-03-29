import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/data/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef SessionDataRepositoryPattern<T> = (RepositoryFailure?, T?);

extension SessionDataRepositoryPatternX<T> on SessionDataRepositoryPattern {
  RepositoryFailure? get failure => $1;

  T? get accountId => $2;
}

abstract class SessionDataKeys {
  static const sessionId = "session_id";
  static const accountId = "account_id";
}

class SessionDataRepository {
  late final SecureStorage _secureStorage;

  SessionDataRepository({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<SessionDataRepositoryPattern<String>> onGetSessionId() async {
    String? sessionId =
        await _secureStorage.get<String?>(SessionDataKeys.sessionId);
    if (sessionId == null) {
      return (
        (1, StackTrace.current, ApiClientExceptionType.auth, ""),
        null,
      );
    }
    return (null, sessionId);
  }

  Future<SessionDataRepositoryPattern<int>> onGetAccountId() async {
    final String? accoutId =
        await _secureStorage.get<String?>(SessionDataKeys.accountId);
    int? parsedId = accoutId != null ? int.tryParse(accoutId) : null;
    if (accoutId == null) {
      return (
        (1, StackTrace.current, ApiClientExceptionType.auth, ""),
        null,
      );
    }
    return (null, parsedId);
  }

  Future<void> onSetSessionId({required String sessionId}) async {
    await _secureStorage.set<String>(SessionDataKeys.sessionId, sessionId);
  }

  Future<void> onSetAccountId({required int accountId}) async {
    await _secureStorage.set<int>(SessionDataKeys.accountId, accountId);
  }

  Future<void> onDeleteSessionId() async {
    await _secureStorage.delete(SessionDataKeys.sessionId);
  }

  Future<void> onDeleteAccountId() async {
    await _secureStorage.delete(SessionDataKeys.accountId);
  }
}
