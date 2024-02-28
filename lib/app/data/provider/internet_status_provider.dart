import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get/get.dart';

enum InternetStatus { connected, disconnected }

class InternetStatusProvider extends GetxController {
  final Rx<InternetStatus> _status = InternetStatus.connected.obs;

  InternetStatus get status => _status.value;

  @override
  void onInit() {
    ConnectivityService().connectivityStream.listen(updateStatus);
    super.onInit();
  }

  void setStatus(InternetStatus status) {
    _status.value = status;
  }

  void updateStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      setStatus(InternetStatus.disconnected);
      mostrarSnackBar();
    } else {
      setStatus(InternetStatus.connected);
    }
  }

  void mostrarSnackBar() {
    Get.snackbar(
      'Sem Conexão',
      'Você está sem conexão com a internet.',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      animationDuration: const Duration(milliseconds: 1500),
      isDismissible: true,
      overlayBlur: 0,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          'Fechar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
