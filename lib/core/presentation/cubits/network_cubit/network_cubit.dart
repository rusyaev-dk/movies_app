import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit({
    required ConnectivityRepository connectivityRepository,
  })  : _connectivityRepository = connectivityRepository,
        super(const NetworkState()) {
    _connectivityStream = _connectivityRepository
        .connectivity.onConnectivityChanged
        .listen(_onConnectivityStateChanged);
  }

  late final ConnectivityRepository _connectivityRepository;
  late final StreamSubscription _connectivityStream;

  void _onConnectivityStateChanged(ConnectivityResult res) {
    if (res == ConnectivityResult.wifi || res == ConnectivityResult.mobile) {
      emit(const NetworkState(type: NetworkStateType.connected));
    } else if (res == ConnectivityResult.none) {
      emit(const NetworkState(type: NetworkStateType.offline));
    } else {
      emit(const NetworkState(type: NetworkStateType.unknown));
    }
  }

  @override
  Future<void> close() {
    _connectivityStream.cancel();
    return super.close();
  }
}
