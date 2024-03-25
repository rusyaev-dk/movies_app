import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/data/api/clients/account_api_client.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

typedef AccountRepositoryPattern<T> = (RepositoryFailure?, T?);

extension AuthRepositoryX<T> on AccountRepositoryPattern {
  RepositoryFailure? get failure => $1;

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

      RepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }

  Future<AccountRepositoryPattern<bool>> onMarkAsFavorite({
    required int accountId,
    required String sessionId,
    required TMDBMediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    try {
      final response = await _accountApiClient.markAsFavourite(
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

      RepositoryFailure repositoryFailure =
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
          AccountModel.fromJSON(response.data as Map<String, dynamic>);
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

      RepositoryFailure repositoryFailure =
          (error, stackTrace, errorParams.$1, errorParams.$2);
      return (repositoryFailure, null);
    } catch (error, stackTrace) {
      return ((error, stackTrace, ApiClientExceptionType.unknown, null), null);
    }
  }
}
