import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectionStatus {
  static Future<bool> verifyConnection() async {
    var conexaoResult = await Connectivity().checkConnectivity();
    return conexaoResult != ConnectivityResult.none;
  }
}

class ConnectivityService {
  Stream<List<ConnectivityResult>> get connectivityStream =>
      Connectivity().onConnectivityChanged;
}
