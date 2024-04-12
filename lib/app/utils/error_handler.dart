import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static void showError(dynamic error) {
    String errorMessage = "Ocorreu um erro inesperado.";

    if (error is String) {
      errorMessage = error;
    } else if (error is Exception) {
      errorMessage = "Erro: ${error.toString()}";
    }

    Get.snackbar(
      "Erro",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
