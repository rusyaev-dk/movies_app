import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/core/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/utils/exceptions.dart';

part 'auth_view_state.dart';

class AuthViewCubit extends Cubit<AuthViewState> {
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authBlocSubscription;

  AuthViewCubit({
    required AuthViewState initialState,
    required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(initialState) {
    _onState(authBloc.state);
    _authBlocSubscription = authBloc.stream.listen(_onState);
  }

  onAuth({required String login, required String password}) {
    if (!_inputDataValidation(login, password)) {
      final state = AuthViewErrorState('Заполните логин и/или пароль');
      emit(state);
      return;
    }
    _authBloc.add(AuthLoginEvent(login: login, password: password));
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
      emit(AuthViewAuthInProgressState());
    } else if (state is AuthStatusCheckInProgressState) {
      emit(AuthViewAuthInProgressState());
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

  bool _inputDataValidation(String login, String password) =>
      login.trim().isNotEmpty && password.trim().isNotEmpty;

  @override
  Future<void> close() {
    _authBlocSubscription.cancel();
    return super.close();
  }
}
