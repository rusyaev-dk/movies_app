import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final AccountRepository _accountRepository;
  late final AuthRepository _authRepository;
  late final SessionDataRepository _sessionDataRepository;

  AuthBloc({
    required AccountRepository accountRepository,
    required AuthRepository authRepository,
    required SessionDataRepository sessionDataRepository,
  })  : _accountRepository = accountRepository,
        _authRepository = authRepository,
        _sessionDataRepository = sessionDataRepository,
        super(AuthUnauthorizedState()) {
    on<AuthEvent>(
      _eventHandlerSwitcher,
      transformer: sequential(),
    );
    add(AuthCheckStatusEvent());
  }

  Future<void> _eventHandlerSwitcher(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event is AuthCheckStatusEvent) {
      await _onAuthCheckStatus(event, emit);
    } else if (event is AuthLoginEvent) {
      await _onAuthLogin(event, emit);
    } else if (event is AuthLogoutEvent) {
      await _onAuthLogout(event, emit);
    }
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthStatusCheckInProgressState) {
      emit(AuthStatusCheckInProgressState());
    }
    final sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();
    switch (sessionDataRepoPattern) {
      case (
          final ApiRepositoryFailure _,
          null,
        ):
        return emit(AuthUnauthorizedState());
      case (null, final String _):
        return emit(AuthAuthorizedState());
    }
  }

  Future<void> _onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthInProgressState) {
      emit(AuthInProgressState());
    }

    String? sessionId;
    final authRepoPattern = await _authRepository.onAuth(
        login: event.login, password: event.password);
    switch (authRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(AuthFailureState(failure));
      case (null, final String resSessionId):
        sessionId = resSessionId;
        break;
    }

    int? accountId;
    final accountRepoPattern =
        await _accountRepository.onGetAccountId(sessionId: sessionId!);
    switch (accountRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(AuthFailureState(failure));
      case (null, final int resAccountId):
        accountId = resAccountId;
        break;
    }

    await _sessionDataRepository.onSetAccountId(accountId: accountId!);
    await _sessionDataRepository.onSetSessionId(sessionId: sessionId);
    emit(AuthAuthorizedState());
  }

  Future<void> _onAuthLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _sessionDataRepository.onDeleteSessionId();
    await _sessionDataRepository.onDeleteAccountId();
    emit(AuthUnauthorizedState());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
