import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/core/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/utils/exceptions.dart';

part 'auth_view_event.dart';
part 'auth_view_state.dart';

class AuthViewBloc extends Bloc<AuthViewEvent, AuthViewState> {
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authBlocSubscription;

  String? login;
  String? password;

  AuthViewBloc({
    required AuthViewState initialState,
    required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(initialState) {
    _onState(authBloc.state);
    _authBlocSubscription = authBloc.stream.listen(_onState);
    on<AuthViewEvent>(_eventHandlerSwitcher);
  }

  _eventHandlerSwitcher(
      AuthViewEvent event, Emitter<AuthViewState> emit) async {
    if (event is AuthViewLoginEvent) {
      await _onAuthViewLogin(event, emit);
    } else if (event is AuthViewPasswordEvent) {
      await _onAuthViewPassword(event, emit);
    } else if (event is AuthViewAuthEvent) {
      await _onAuthViewAuth(event, emit);
    }
  }

  _onAuthViewLogin(AuthViewLoginEvent event, Emitter<AuthViewState> emit) {
    if (event.login.isNotEmpty) {
      login = event.login;
    }
  }

  _onAuthViewPassword(
      AuthViewPasswordEvent event, Emitter<AuthViewState> emit) {
    if (event.password.isNotEmpty) {
      password = event.password;
    }
  }

  _onAuthViewAuth(AuthViewAuthEvent event, Emitter<AuthViewState> emit) {
    if (login == null || password == null) {
      final state = AuthViewErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }
    if (!_isValid(login!, password!)) {
      final state = AuthViewErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }
    _authBloc.add(AuthLoginEvent(login: login!, password: password!));
  }

  void _onState(AuthState state) {
    if (state is AuthUnauthorizedState) {
      emit(AuthViewFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      _authBlocSubscription.cancel();
      emit(AuthViewSuccessState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewInProgressState());
    } else if (state is AuthStatusCheckInProgressState) {
      emit(AuthViewInProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Неизвестная ошибка, поторите попытку...';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Сервер недоступен. Проверьте подключение к интернету';
      case ApiClientExceptionType.auth:
        return 'Неверный логин и/или пароль!';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.jsonKey:
        return ""; // ПОДПРАВИТЬ
      case ApiClientExceptionType.other:
        return 'Произошла ошибка. Попробуйте ещё раз...';
    }
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  @override
  Future<void> close() {
    _authBlocSubscription.cancel();
    return super.close();
  }
}
