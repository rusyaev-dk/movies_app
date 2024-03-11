import 'package:movies_app/core/data/api/clients/auth_api_client.dart';

class AuthRepository {
  static final _authApiClient = AuthApiClient();

  Future<String> onAuth({
    required String login,
    required String password,
  }) async {
    final tokenResponse = await _authApiClient.getToken();
    final String token = tokenResponse.data["request_token"] as String;

    final validateResponse = await _authApiClient.validateUser(
      login: login,
      password: password,
      requestToken: token,
    );
    final String validToken = validateResponse.data["request_token"] as String;

    final sessionResponse =
        await _authApiClient.getSessionId(requestToken: validToken);
    final String sessionId = sessionResponse.data["session_id"] as String;

    return sessionId;
  }
}
