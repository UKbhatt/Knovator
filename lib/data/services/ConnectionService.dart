import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();

  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
