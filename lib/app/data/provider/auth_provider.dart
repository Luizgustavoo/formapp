import 'dart:convert';

import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  final http.Client httpClient = http.Client();

  Future<Map<String, dynamic>?> getLogin(
      String username, String password) async {
    var loginUrl = Uri.parse('$baseUrl/login');
    try {
      var response = await httpClient
          .post(loginUrl, body: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw AuthenticationException(
            'Erro de autenticação: Usuário ou senha inválidos');
      } else {
        throw Exception('Erro - get:${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<void> getLogout() async {
    var loginUrl = Uri.parse('$baseUrl/v1/logout');
    try {
      var response = await httpClient.post(
        loginUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${UserStorage.getToken()}",
        },
      );
      if (response.statusCode == 200) {
        UserStorage.clearBox();
        Get.offAllNamed('/login');
      } else {
        throw Exception('Erro ao fazer logout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  Future<Map<String, dynamic>?> forgotPassword(String username) async {
    var forgotUrl = Uri.parse('$baseUrl/forgot-password');
    try {
      var response = await httpClient.post(forgotUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${UserStorage.getToken()}",
      }, body: {
        'username': username
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao redefinir senha: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao redefinir senha: $e');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => message;
}
