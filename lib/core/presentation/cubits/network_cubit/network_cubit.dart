import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final ConnectivityRepository _connectivityRepository;
  late final StreamSubscription _connectivityStream;

  NetworkCubit({
    required ConnectivityRepository connectivityRepository,
  })  : _connectivityRepository = connectivityRepository,
        super(NetworkState()) {
    _connectivityStream = _connectivityRepository
        .connectivity.onConnectivityChanged
        .listen((ConnectivityResult res) {
      if (res == ConnectivityResult.wifi || res == ConnectivityResult.mobile) {
        emit(NetworkState(type: NetworkStateType.connected));
      } else if (res == ConnectivityResult.none) {
        emit(NetworkState(type: NetworkStateType.offline));
      } else {
        emit(NetworkState(type: NetworkStateType.unknown));
      }
    });
  }

  Future<bool> isConnected() async {
    return await _connectivityRepository.isConnected();
  }

  @override
  Future<void> close() {
    _connectivityStream.cancel();
    return super.close();
  }
}
