import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:movies_app/core/data/api/clients/account_api_client.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef AccountRepositoryPattern<T> = (ApiRepositoryFailure?, T?);

extension AuthRepositoryX<T> on AccountRepositoryPattern {
  ApiRepositoryFailure? get failure => $1;

  T? get accountId => $2;
}

class AccountRepository {
  static final AccountApiClient _accountApiClient = AccountApiClient();
  static final RepositoryFailureFormatter _failureFormatter = RepositoryFailureFormatter();
  final Logger _logger = Logger("AccountRepo");

  Future<AccountRepositoryPattern<int>> onGetAccountId(
      {required String sessionId}) async {
    try {
      final response =
          await _accountApiClient.getAccountId(sessionId: sessionId);
      return (null, response.data["id"] as int);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<AccountRepositoryPattern<bool>> onAddToFavourite({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isFavourite,
  }) async {
    try {
      final response = await _accountApiClient.addToFavourite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: mediaType,
        mediaId: mediaId,
        isFavourite: isFavourite,
      );

      return (null, response.data["success"] as bool);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<AccountRepositoryPattern<bool>> onAddToWatchlist({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isInWatchlist,
  }) async {
    try {
      final response = await _accountApiClient.addToWatchlist(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: mediaType,
        mediaId: mediaId,
        isInWatchlist: isInWatchlist,
      );

      return (null, response.data["success"] as bool);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return (
        (exception, stackTrace, ApiClientExceptionType.unknown, null),
        null
      );
    }
  }

  Future<AccountRepositoryPattern<AccountModel>> onGetAccountDetails({
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final response = await _accountApiClient.getAccountDetails(
        accountId: accountId,
        sessionId: sessionId,
      );

      final AccountModel account =
          AccountModel.fromJson(response.data as Map<String, dynamic>);
      return (null, account);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return ((exception, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<AccountRepositoryPattern<List<T>>> onGetAccountMediaWatchList<T>({
    required TMDBMediaType mediaType,
    required String locale,
    required int page,
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final Response? response;
      final TMDBModel Function(Map<String, dynamic>)? fromJson;
      switch (mediaType) {
        case TMDBMediaType.movie:
          response = await _accountApiClient.getAccountMoviesWatchList(
            locale: locale,
            page: page,
            accountId: accountId,
            sessionId: sessionId,
          );
          fromJson = MovieModel.fromJson;
        case TMDBMediaType.tv:
          response = await _accountApiClient.getAccountTVSeriesWatchList(
            locale: locale,
            page: page,
            accountId: accountId,
            sessionId: sessionId,
          );
          fromJson = TVSeriesModel.fromJson;
        default:
          response = null;
          fromJson = null;
      }

      final List<T> models = (response!.data["results"] as List)
          .map((json) => fromJson!(json) as T)
          .toList();
      return (null, models);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return ((exception, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<AccountRepositoryPattern<Map<String, bool>>> onGetAccountStates({
    required TMDBMediaType mediaType,
    required int mediaId,
    required String sessionId,
  }) async {
    try {
      final Response? response;
      switch (mediaType) {
        case (TMDBMediaType.movie):
          response = await _accountApiClient.getMovieAccountStates(
              movieId: mediaId, sessionId: sessionId);
        case (TMDBMediaType.tv):
          response = await _accountApiClient.getTvSeriesAccountStates(
              tvSeriesId: mediaId, sessionId: sessionId);
        default:
          response = null;
      }

      final Map<String, bool> accountStateMap = {
        "favourite": response!.data["favorite"] ?? false,
        "watchlist": response.data["watchlist"] ?? false,
      };

      return (null, accountStateMap);
    } on ApiClientException catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");

      final error = exception.error;
      final errorParams = _failureFormatter.getApiErrorParams(error, exception);
      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);

      return (repositoryFailure, null);
    } catch (exception, stackTrace) {
      _logger.severe("Exception caught: $exception. StackTrace: $stackTrace");
      return ((exception, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
