import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/data/api/clients/account_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef AccountRepositoryPattern<T> = (ApiRepositoryFailure?, T?);

extension AuthRepositoryX<T> on AccountRepositoryPattern {
  ApiRepositoryFailure? get failure => $1;

  T? get accountId => $2;
}

class AccountRepository {
  static final AccountApiClient _accountApiClient = AccountApiClient();

  Future<AccountRepositoryPattern<int>> onGetAccountId(
      {required String sessionId}) async {
    try {
      final response =
          await _accountApiClient.getAccountId(sessionId: sessionId);
      return (null, response.data["id"] as int);
    } on ApiClientException catch (exception, stackTrace) {
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<AccountRepositoryPattern<bool>> onAddFavourite({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    try {
      final response = await _accountApiClient.addFavourite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: mediaType,
        mediaId: mediaId,
        isFavorite: isFavorite,
      );

      return (null, response.data["status_code"] == 1);
    } on ApiClientException catch (exception, stackTrace) {
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
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
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
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
      final error = exception.error;
      final errorParams = switch (error) {
        DioException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        FormatException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        HttpException _ => (
            ApiClientExceptionType.network,
            (error).message,
          ),
        TimeoutException _ => (
            ApiClientExceptionType.network,
            (error).message ?? exception.message,
          ),
        _ => (ApiClientExceptionType.unknown, exception.message),
      };

      ApiRepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  // Future<AccountRepositoryPattern<bool>> onIsFavourite({
  //   required TMDBMediaType mediaType,
  //   required int mediaId,
  //   required int accountId,
  //   required String sessionId,
  // }) async {
  //   try {
  //     await onGetAccountFavouriteMedia(mediaType: mediaType, locale: "en-US", page: 1, accountId: accountId, sessionId: sessionId)
  //   } on ApiClientException catch (exception, stackTrace) {
  //     final error = exception.error;
  //     final errorParams = switch (error) {
  //       DioException _ => (
  //           ApiClientExceptionType.network,
  //           (error).message,
  //         ),
  //       FormatException _ => (
  //           ApiClientExceptionType.network,
  //           (error).message,
  //         ),
  //       HttpException _ => (
  //           ApiClientExceptionType.network,
  //           (error).message,
  //         ),
  //       TimeoutException _ => (
  //           ApiClientExceptionType.network,
  //           (error).message ?? exception.message,
  //         ),
  //       _ => (ApiClientExceptionType.unknown, exception.message),
  //     };

  //     RepositoryFailure repositoryFailure =
  //         (error, stackTrace, errorParams.$1, errorParams.$2);
  //     return (repositoryFailure, null);
  //   } catch (error, stackTrace) {
  //     return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
  //   }
  // }
}
