import 'package:movies_app/core/data/storage/secure_storage.dart';

abstract class SessionDataKeys {
  static const sessionId = "session_id";
  static const accountId = "account_id";
}

class SessionDataRepository {
  late final SecureStorage _secureStorage;

  SessionDataRepository({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<String?> onGetSessionId() async {
    return await _secureStorage.get<String>(SessionDataKeys.sessionId);
  }

  Future<int?> onGetAccountId() async {
    final String? accoutId =
        await _secureStorage.get<String>(SessionDataKeys.accountId);
    return accoutId != null ? int.tryParse(accoutId) : null;
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
