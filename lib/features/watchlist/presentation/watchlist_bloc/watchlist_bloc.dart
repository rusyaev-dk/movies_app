import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  late final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;

  WatchlistBloc({
    required NetworkCubit networkCubit,
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
  })  : _networkCubit = networkCubit,
        _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        super(WatchlistState()) {
    Future.microtask(
      () {
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<WatchlisrNetworkErrorEvent>(_onNetworkError);
    on<WatchlistloadWatchlistEvent>(_onLoadWatchlist);
    on<WatchlistRefreshWatchlistEvent>(_onRefreshWatchlist);
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline ||
        state.type == NetworkStateType.unknown) {
      add(WatchlisrNetworkErrorEvent());
    } else if (state.type == NetworkStateType.connected) {
      add(WatchlistloadWatchlistEvent());
    }
  }

  void _onNetworkError(
    WatchlisrNetworkErrorEvent event,
    Emitter<WatchlistState> emit,
  ) {
    emit(WatchlistFailureState(
        failure: (1, StackTrace.current, ApiClientExceptionType.network, "")));
  }

  Future<void> _onLoadWatchlist(
    WatchlistloadWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoadingState());

    String? sessionId;
    int? accountId;

    SessionDataRepositoryPattern sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(WatchlistFailureState(failure: failure));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetAccountId();
    switch (sessionDataRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(WatchlistFailureState(failure: failure));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    List<MovieModel>? favouriteMovies;
    AccountRepositoryPattern accountRepositoryPattern =
        await _accountRepository.onGetAccountMediaWatchList<MovieModel>(
      mediaType: TMDBMediaType.movie,
      locale: event.locale,
      page: event.page,
      accountId: accountId!,
      sessionId: sessionId!,
    );

    switch (accountRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(WatchlistFailureState(failure: failure));
      case (null, final List<MovieModel> resMovieModels):
        favouriteMovies = resMovieModels;
    }

    accountRepositoryPattern =
        await _accountRepository.onGetAccountMediaWatchList<TVSeriesModel>(
      mediaType: TMDBMediaType.tv,
      locale: event.locale,
      page: event.page,
      accountId: accountId,
      sessionId: sessionId,
    );

    switch (accountRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(WatchlistFailureState(failure: failure));
      case (null, final List<TVSeriesModel> resTVSeriesModels):
        return emit(WatchlistLoadedState(
          moviesWatchlist: favouriteMovies!,
          tvSeriesWatchlist: resTVSeriesModels,
        ));
    }
  }

  Future<void> _onRefreshWatchlist(
    WatchlistRefreshWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    add(WatchlistloadWatchlistEvent());
    event.refreshController.refreshCompleted();
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }
}
