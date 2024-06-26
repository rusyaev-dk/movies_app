import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/common/domain/models/tmdb_models.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:movies_app/common/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late final NetworkCubit _networkCubit;
  late final StreamSubscription<NetworkState> _networkCubitSubscription;
  late final SessionDataRepository _sessionDataRepository;
  late final AccountRepository _accountRepository;

  AccountBloc({
    required NetworkCubit networkCubit,
    required SessionDataRepository sessionDataRepository,
    required AccountRepository accountRepository,
  })  : _networkCubit = networkCubit,
        _sessionDataRepository = sessionDataRepository,
        _accountRepository = accountRepository,
        super(AccountLoadingState()) {
    Future.microtask(
      () {
        _networkCubitSubscription =
            _networkCubit.stream.listen(_onNetworkStateChanged);
      },
    );

    on<AccountNetworkErrorEvent>(_onNetworkError);
    on<AccountLoadAccountDetailsEvent>(_onLoadProfileInfo);
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state.type == NetworkStateType.offline ||
        state.type == NetworkStateType.unknown) {
      add(AccountNetworkErrorEvent());
    } else if (state.type == NetworkStateType.connected) {
      add(AccountLoadAccountDetailsEvent());
    }
  }

  void _onNetworkError(
    AccountNetworkErrorEvent event,
    Emitter<AccountState> emit,
  ) {
    emit(AccountFailureState(
        failure: (1, StackTrace.current, ApiClientExceptionType.network, "")));
  }

  Future<void> _onLoadProfileInfo(
    AccountLoadAccountDetailsEvent event,
    Emitter<AccountState> emit,
  ) async {
    if (state is! AccountLoadedState) {
      emit(AccountLoadingState());
    }

    String? sessionId;
    int? accountId;

    SessionDataRepositoryPattern sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetSessionId();

    switch (sessionDataRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        event.completer?.complete();
        return emit(AccountFailureState(failure: failure));
      case (null, final String resSessionId):
        sessionId = resSessionId;
    }

    sessionDataRepositoryPattern =
        await _sessionDataRepository.onGetAccountId();
    switch (sessionDataRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        event.completer?.complete();
        return emit(AccountFailureState(failure: failure));
      case (null, final int resAccountId):
        accountId = resAccountId;
    }

    AccountRepositoryPattern accountRepositoryPattern =
        await _accountRepository.onGetAccountDetails(
      accountId: accountId!,
      sessionId: sessionId!,
    );

    event.completer?.complete();
    switch (accountRepositoryPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(AccountFailureState(failure: failure));
      case (null, final AccountModel resAccountModel):
        return emit(AccountLoadedState(account: resAccountModel));
    }
  }

  @override
  Future<void> close() {
    _networkCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
