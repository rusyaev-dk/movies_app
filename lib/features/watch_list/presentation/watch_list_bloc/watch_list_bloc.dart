import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;

  WatchListBloc({
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
  })  : _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        super(WatchListState()) {
    on<WatchListLoadWatchListEvent>(_onLoadWatchList);
    on<WatchListRefreshWatchListEvent>(_onRefreshWatchList);
  }

  Future<void> _onLoadWatchList(
    WatchListLoadWatchListEvent event,
    Emitter<WatchListState> emit,
  ) async {
    emit(WatchListLoadingState());

    String? sessionId;
    int? accountId;

    SessionDataRepositoryPattern sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepositoryPattern) {
      case (final RepositoryFailure failure, null):
        return emit(WatchListFailureState(failure: failure));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetAccountId();
    switch (sessionDataRepositoryPattern) {
      case (final RepositoryFailure failure, null):
        return emit(WatchListFailureState(failure: failure));
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
      case (final RepositoryFailure failure, null):
        return emit(WatchListFailureState(failure: failure));
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
      case (final RepositoryFailure failure, null):
        return emit(WatchListFailureState(failure: failure));
      case (null, final List<TVSeriesModel> resTVSeriesModels):
        return emit(WatchListLoadedState(
          moviesWatchList: favouriteMovies!,
          tvSeriesWatchList: resTVSeriesModels,
        ));
    }
  }

  Future<void> _onRefreshWatchList(
    WatchListRefreshWatchListEvent event,
    Emitter<WatchListState> emit,
  ) async {
    add(WatchListLoadWatchListEvent());
    event.refreshController.refreshCompleted();
  }
}
