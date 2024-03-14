part of "network_cubit.dart";

enum NetworkStateType {
  connected,
  offline,
  unknown,
}

class NetworkState {
  final NetworkStateType type;

  NetworkState({
    this.type = NetworkStateType.unknown,
  });
}
