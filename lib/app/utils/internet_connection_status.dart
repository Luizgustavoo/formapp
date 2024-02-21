import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConectionController extends GetxController {
  var statusConexao = Rx<ConnectivityResult>(ConnectivityResult.none);

  @override
  void onInit() {
    super.onInit();
    verificarConexao();
    Connectivity().onConnectivityChanged.listen((result) {
      statusConexao.value = result;
    });
  }

  Future<void> verificarConexao() async {
    var conexaoResult = await Connectivity().checkConnectivity();
    statusConexao.value = conexaoResult;
  }

  bool estaConectado() {
    return statusConexao.value != ConnectivityResult.none;
  }
}

abstract class ConnectionStatus {
  static Future<bool> verificarConexao() async {
    var conexaoResult = await Connectivity().checkConnectivity();
    return conexaoResult != ConnectivityResult.none;
  }
}
