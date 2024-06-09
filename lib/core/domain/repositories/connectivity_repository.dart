import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepository {
  late final Connectivity _connectivity;

  ConnectivityRepository({
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  Connectivity get connectivity => _connectivity;
}
