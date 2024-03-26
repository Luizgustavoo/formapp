import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/utils/user_storage.dart';

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
        print('Erro de autenticação: Usuário ou senha inválidos');
        // Adicione uma lógica para tratar o erro de autenticação aqui
      } else {
        print('Erro - get:${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLogout() async {
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
      }
    } catch (e) {
      print(e);
    }
    return null;
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
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
