import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;
  late final StreamSubscription _connectivityStream;

  NetworkCubit({
    required Connectivity connectivity,
  })  : _connectivity = connectivity,
        super(NetworkState()) {
    _connectivity.checkConnectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.listen((ConnectivityResult res) {
      if (res == ConnectivityResult.wifi || res == ConnectivityResult.mobile) {
        emit(NetworkState(type: NetworkStateType.connected));
      } else if (res == ConnectivityResult.none) {
        emit(NetworkState(type: NetworkStateType.offline));
      } else {
        emit(NetworkState(type: NetworkStateType.unknown));
      }
    });
  }

  @override
  Future<void> close() {
    _connectivityStream.cancel();
    return super.close();
  }
}
