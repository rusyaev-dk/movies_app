import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:movies_app/core/presentation/auth_bloc/auth_bloc.dart';


enum ScreenLoaderState { unknown, authorized, unAuthorized }

class ScreenLoaderCubit extends Cubit<ScreenLoaderState> {
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authBlocSubscription;

  ScreenLoaderCubit({
    required ScreenLoaderState initialState,
    required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(initialState) {
    Future.microtask(
      () {
        _onState(authBloc.state);
        _authBlocSubscription = _authBloc.stream.listen(_onState);
        _authBloc.add(AuthCheckStatusEvent());
      },
    );
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(ScreenLoaderState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(ScreenLoaderState.unAuthorized);
    }
  }

  @override
  Future<void> close() {
    _authBlocSubscription.cancel();
    return super.close();
  }
}
