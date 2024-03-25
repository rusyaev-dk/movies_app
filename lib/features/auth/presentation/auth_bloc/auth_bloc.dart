import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/auth_repository.dart';

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
    // add(AuthLogoutEvent()); // убрать в финалке!!!
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
    emit(AuthStatusCheckInProgressState());
    final sessionDataRepoPattern =
        await _sessionDataRepository.onGetSessionId();
    switch (sessionDataRepoPattern) {
      case (final RepositoryFailure _, null,):
        return emit(AuthUnauthorizedState());
      case (null, final String _):
        return emit(AuthAuthorizedState());
    }
  }

  Future<void> _onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInProgressState());

    String? sessionId;
    final authRepoPattern = await _authRepository.onAuth(
        login: event.login, password: event.password);
    switch (authRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(AuthFailureState(failure));
      case (null, final String patternSessionId):
        sessionId = patternSessionId;
        break;
    }

    int? accountId;
    final accountRepoPattern =
        await _accountRepository.onGetAccountId(sessionId: sessionId!);
    switch (accountRepoPattern) {
      case (final RepositoryFailure failure, null):
        return emit(AuthFailureState(failure));
      case (null, final int patternAccountId):
        accountId = patternAccountId;
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
}
