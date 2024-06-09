part of "network_cubit.dart";

enum NetworkStateType {
  connected,
  offline,
  unknown,
}

final class NetworkState extends Equatable{
  final NetworkStateType type;

  const NetworkState({
    this.type = NetworkStateType.unknown,
  });
  
  @override
  List<Object?> get props => [type];
}
