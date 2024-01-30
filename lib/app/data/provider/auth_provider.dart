import 'dart:convert';

import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/auth_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  final http.Client httpClient = http.Client();

  Future<Auth?> getLogin(String username, String password) async {
    var loginUrl = Uri.parse('$baseUrl/login');
    try {
      var response = await httpClient
          .post(loginUrl, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        var auth = Auth.fromJson(json.decode(response.body));
        // Armazena as informações do usuário no GetStorage
        GetStorage('credenciado').write('auth', auth.user?.toJson());
        return auth;
      } else {
        print('Erro - get: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
