import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies_app/core/domain/repositories/tmdb_session_data_repository.dart';
import 'package:movies_app/core/domain/repositories/tmdb_account_repository.dart';
import 'package:movies_app/core/domain/repositories/tmdb_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final TMDBAccountRepository _tmdbAccountRepository;
  late final TMDBAuthRepository _tmdbAuthRepository;
  late final TMDBSessionDataRepository _tmdbSessionDataRepository;

  AuthBloc({
    required TMDBAccountRepository tmdbAccountRepository,
    required TMDBAuthRepository tmdbAuthRepository,
    required TMDBSessionDataRepository tmdbSessionDataRepository,
  })  : _tmdbAccountRepository = tmdbAccountRepository,
        _tmdbAuthRepository = tmdbAuthRepository,
        _tmdbSessionDataRepository = tmdbSessionDataRepository,
        super(AuthUnauthorizedState()) {
    on<AuthEvent>(_eventHandlerSwitcher, transformer: sequential());
    add(AuthLogoutEvent()); // убрать в финалке!!!
    add(AuthCheckStatusEvent());
  }

  _eventHandlerSwitcher(AuthEvent event, Emitter<AuthState> emit) async {
    if (event is AuthCheckStatusEvent) {
      await _onAuthCheckStatus(event, emit);
    } else if (event is AuthLoginEvent) {
      await _onAuthLogin(event, emit);
    } else if (event is AuthLogoutEvent) {
      await _onAuthLogout(event, emit);
    }
  }

  _onAuthCheckStatus(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStatusCheckInProgressState());
      final sessionId = await _tmdbSessionDataRepository.onGetSessionId();
      final newState =
          sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
      emit(newState);
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }

  _onAuthLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgressState());
      final sessionId = await _tmdbAuthRepository.onAuth(
        login: event.login,
        password: event.password,
      );
      final accountId =
          await _tmdbAccountRepository.onGetAccountId(sessionId: sessionId);
      await _tmdbSessionDataRepository.onSetAccountId(accountId: accountId);
      await _tmdbSessionDataRepository.onSetSessionId(sessionId: sessionId);
      emit(AuthAuthorizedState());
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }

  _onAuthLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _tmdbSessionDataRepository.onDeleteSessionId();
      await _tmdbSessionDataRepository.onDeleteAccountId();
    } catch (err) {
      emit(AuthFailureState(err));
    }
  }
}
