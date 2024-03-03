import 'package:movies_app/core/data/storage/secure_storage.dart';

abstract class TMDBSessionDataKeys {
  static const sessionId = "session_id";
  static const accountId = "account_id";
}

class TMDBSessionDataRepository {
  late final SecureStorage _secureStorage;

  TMDBSessionDataRepository({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<String?> onGetSessionId() async {
    final String? sessionId =
        await _secureStorage.get<String>(TMDBSessionDataKeys.sessionId);
    return sessionId;
  }

  Future<int?> onGetAccountId() async {
    final String? accoutId =
        await _secureStorage.get<String>(TMDBSessionDataKeys.accountId);
    return accoutId != null ? int.tryParse(accoutId) : null;
  }

  Future<void> onSetSessionId({required String sessionId}) async {
    return _secureStorage.set<String>(TMDBSessionDataKeys.sessionId, sessionId);
  }

  Future<void> onSetAccountId({required int accountId}) async {
    return _secureStorage.set<int>(TMDBSessionDataKeys.accountId, accountId);
  }

  Future<void> onDeleteSessionId() async {
    return _secureStorage.delete(TMDBSessionDataKeys.sessionId);
  }

  Future<void> onDeleteAccountId() async {
    return _secureStorage.delete(TMDBSessionDataKeys.accountId);
  }
}
