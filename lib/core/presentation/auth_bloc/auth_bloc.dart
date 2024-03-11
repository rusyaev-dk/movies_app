import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
      AuthEvent event, Emitter<AuthState> emit) async {
    if (event is AuthCheckStatusEvent) {
      await _onAuthCheckStatus(event, emit);
    } else if (event is AuthLoginEvent) {
      await _onAuthLogin(event, emit);
    } else if (event is AuthLogoutEvent) {
      await _onAuthLogout(event, emit);
    }
  }

  Future<void> _onAuthCheckStatus(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStatusCheckInProgressState());
      final sessionId = await _sessionDataRepository.onGetSessionId();
      final newState =
          sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
      emit(newState);
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }

  Future<void> _onAuthLogin(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgressState());
      final sessionId = await _authRepository.onAuth(
        login: event.login,
        password: event.password,
      );
      final accountId =
          await _accountRepository.onGetAccountId(sessionId: sessionId);
      await _sessionDataRepository.onSetAccountId(accountId: accountId);
      await _sessionDataRepository.onSetSessionId(sessionId: sessionId);
      emit(AuthAuthorizedState());
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }

  Future<void> _onAuthLogout(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataRepository.onDeleteSessionId();
      await _sessionDataRepository.onDeleteAccountId();
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }
}
