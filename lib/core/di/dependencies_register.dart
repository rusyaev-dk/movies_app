import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/api/clients/account_api_client.dart';
import 'package:movies_app/core/data/api/clients/auth_api_client.dart';
import 'package:movies_app/core/data/api/clients/media_api_client.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/core/data/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> registerDependencies() async {
  final Dio dio = Dio();
  if (kDebugMode) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: GetIt.I<Talker>(),
        settings: const TalkerDioLoggerSettings(
          printRequestData: false,
          printRequestHeaders: false,
          printResponseData: false,
          printResponseHeaders: false,
        ),
      ),
    );
  }

  final httpClient = AppHttpClient(dio: dio);
  final accountApiClient = AccountApiClient(httpClient: httpClient);
  final authApiClient = AuthApiClient(httpClient: httpClient);
  final mediaApiClient = MediaApiClient(httpClient: httpClient);
  final secureStorage = SecureStorage(storage: const FlutterSecureStorage());

  final prefs = await SharedPreferences.getInstance();
  final keyValueStorage = KeyValueStorage(prefs: prefs);

  GetIt.I.registerSingleton<AuthRepository>(
      AuthRepository(authApiClient: authApiClient));
  GetIt.I.registerSingleton<MediaRepository>(
      MediaRepository(mediaApiClient: mediaApiClient));
  GetIt.I.registerSingleton<AccountRepository>(
      AccountRepository(accountApiClient: accountApiClient));
  GetIt.I.registerSingleton<SessionDataRepository>(
      SessionDataRepository(secureStorage: secureStorage));
  GetIt.I.registerSingleton<KeyValueStorageRepository>(
      KeyValueStorageRepository(storage: keyValueStorage));
  GetIt.I.registerSingleton<ConnectivityRepository>(
      ConnectivityRepository(connectivity: Connectivity()));
  GetIt.I.registerSingleton<SearchFiltersRepository>(SearchFiltersRepository(
      keyValueStorageRepository: GetIt.I<KeyValueStorageRepository>()));
}
