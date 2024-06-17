import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/clients/account_api_client.dart';
import 'package:movies_app/core/data/clients/auth_api_client.dart';
import 'package:movies_app/core/data/clients/media_api_client.dart';
import 'package:movies_app/core/data/clients/http_client.dart';
import 'package:movies_app/persistence/storage/shared_prefs_storage.dart';
import 'package:movies_app/persistence/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
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

  final prefs = await SharedPreferences.getInstance();
  final sharedPrefsStorage = SharedPrefsStorage(prefs: prefs);
  final secureStorage = SecureStorage(storage: const FlutterSecureStorage());

  final repoFailureFormatter = RepositoryFailureFormatter();

  GetIt.I.registerSingleton<AuthRepository>(AuthRepository(
    authApiClient: authApiClient,
    repositoryFailureFormatter: repoFailureFormatter,
  ));
  GetIt.I.registerSingleton<MediaRepository>(MediaRepository(
    mediaApiClient: mediaApiClient,
    repositoryFailureFormatter: repoFailureFormatter,
  ));
  GetIt.I.registerSingleton<AccountRepository>(AccountRepository(
    accountApiClient: accountApiClient,
    repositoryFailureFormatter: repoFailureFormatter,
  ));
  GetIt.I.registerSingleton<SessionDataRepository>(
      SessionDataRepository(secureStorage: secureStorage));
  GetIt.I.registerSingleton<ConnectivityRepository>(
      ConnectivityRepository(connectivity: Connectivity()));
  
  GetIt.I.registerSingleton<SharedPrefsStorage>(sharedPrefsStorage);

  
  GetIt.I.registerSingleton<SearchFiltersRepository>(SearchFiltersRepository(
      keyValueStorage: GetIt.I<SharedPrefsStorage>()));
}
