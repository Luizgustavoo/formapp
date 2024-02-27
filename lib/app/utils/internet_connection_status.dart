import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/login_modal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

abstract class ConnectionStatus {
  static Future<bool> verifyConnection() async {
    var conexaoResult = await Connectivity().checkConnectivity();
    return conexaoResult != ConnectivityResult.none;
  }

  static void tokenExpired() {
    final box = GetStorage('credenciado');

    Get.defaultDialog(
      title: "Expirou",
      content:
          const Text('O token de autenticação expirou, faça login novamente.'),
    );

    box.erase();
    // Get.offAllNamed('/login');
    // if (authData != null) {
    //   final expiresIn = authData['expires_in'] as String?;
    //   if (expiresIn != null) {
    //     final expirationDate = DateTime.parse(expiresIn);
    //     return DateTime.now().isAfter(expirationDate);
    //   }
    // }
  }

  static void showModalLogin() {
    Get.dialog(LoginModal());
  }
}
