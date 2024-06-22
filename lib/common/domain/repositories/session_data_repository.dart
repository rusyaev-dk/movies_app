import 'package:get_it/get_it.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/persistence/storage/storage_interface.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:talker_flutter/talker_flutter.dart';

typedef SessionDataRepositoryPattern<T> = (ApiRepositoryFailure?, T?);

extension SessionDataRepositoryPatternX<T> on SessionDataRepositoryPattern {
  ApiRepositoryFailure? get failure => $1;

  T? get accountId => $2;
}

abstract class SessionDataKeys {
  static const sessionId = "session_id";
  static const accountId = "account_id";
}

class SessionDataRepository {
  SessionDataRepository({
    required KeyValueStorage secureStorage,
  }) : _secureStorage = secureStorage;

  late final KeyValueStorage _secureStorage;

  Future<SessionDataRepositoryPattern<String>> onGetSessionId() async {
    String? sessionId =
        await _secureStorage.get<String?>(key: SessionDataKeys.sessionId);
    if (sessionId == null) {
      GetIt.I<Talker>().error(
          "Exception caught: $ApiAuthException. StackTrace: ${StackTrace.current}");
      return (
        (1, StackTrace.current, ApiClientExceptionType.auth, ""),
        null,
      );
    }
    return (null, sessionId);
  }

  Future<SessionDataRepositoryPattern<int>> onGetAccountId() async {
    final String? accoutId =
        await _secureStorage.get<String?>(key: SessionDataKeys.accountId);
    int? parsedId = accoutId != null ? int.tryParse(accoutId) : null;
    if (accoutId == null) {
      GetIt.I<Talker>().error(
          "Exception caught: $ApiAuthException. StackTrace: ${StackTrace.current}");
      return (
        (1, StackTrace.current, ApiClientExceptionType.auth, ""),
        null,
      );
    }
    return (null, parsedId);
  }

  Future<void> onSetSessionId({required String sessionId}) async {
    await _secureStorage.set<String>(
      key: SessionDataKeys.sessionId,
      value: sessionId,
    );
  }

  Future<void> onSetAccountId({required int accountId}) async {
    await _secureStorage.set<int>(
      key: SessionDataKeys.accountId,
      value: accountId,
    );
  }

  Future<void> onDeleteSessionId() async {
    await _secureStorage.delete(key: SessionDataKeys.sessionId);
  }

  Future<void> onDeleteAccountId() async {
    await _secureStorage.delete(key: SessionDataKeys.accountId);
  }
}
