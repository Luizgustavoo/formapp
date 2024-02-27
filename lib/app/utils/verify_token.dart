import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/login_modal.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class VerifyToken {
  static bool isTokenExpired(BuildContext context) {
    final box = GetStorage('credenciado');
    final token = box.read('auth')['access_token'].toString();
    print(token);
    try {
      if (JwtDecoder.isExpired(token)) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginModal();
          },
        );
      }

      return JwtDecoder.isExpired(token);
    } catch (e) {
      print("Erro ao decodificar ou verificar o token: $e");
      return true; // Assumindo que um token inválido seja considerado expirado
    }
  }
}
