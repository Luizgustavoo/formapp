import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserApiClient {
  final http.Client httpClient = http.Client();
  final box = GetStorage('credenciado');

  getAll(String token) async {
    final id = box.read('auth')['user']['id'];
    try {
      var userUrl = Uri.parse('$baseUrl/v1/usuario/list/id/$id');
      var response = await httpClient.get(
        userUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
              'O token de autenticação expirou, faça login novamente.'),
        );
        var box = GetStorage('credenciado');
        box.erase();
        Get.offAllNamed('/login');
      } else {
        Get.defaultDialog(
          title: "Error",
          content: const Text('erro'),
        );
      }
    } catch (err) {
      Get.defaultDialog(
        title: "Error",
        content: Text("$err"),
      );
    }
    return null;
  }

  insertUser(String token, User user) async {
    try {
      var userUrl = Uri.parse('$baseUrl/v1/usuario/create');

      var requestBody = {
        "nome": user.nome,
        "tipousuario_id": user.tipousuarioId.toString(),
        "username": user.username,
        "password": user.password,
        "status": user.status.toString(),
        "usuario_id": user.usuarioId.toString(),
      };

      var response = await httpClient.post(
        userUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
        body: requestBody,
      );
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 422 ||
          json.decode(response.body)['message'] == "ja_existe") {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
              'O token de autenticação expirou, faça login novamente.'),
        );
        var box = GetStorage('credenciado');
        box.erase();
        Get.offAllNamed('/login');
      } else {
        Get.defaultDialog(
          title: "Error",
          content: const Text('erro'),
        );
      }
    } catch (err) {
      Get.defaultDialog(
        title: "Errorou",
        content: Text("$err"),
      );
    }
    return null;
  }

  updateUser(String token, User user) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/update/${user.id}');

      var requestBody = {
        "nome": user.nome,
        "tipousuario_id": user.tipousuarioId.toString(),
        "username": user.username,
        "password": user.password,
        "status": user.status.toString(),
        "usuario_id": user.usuarioId.toString(),
      };

      var response = await httpClient.put(
        familyUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
        body: requestBody,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 422 ||
          json.decode(response.body)['message'] == "ja_existe") {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
              'O token de autenticação expirou, faça login novamente.'),
        );
        var box = GetStorage('credenciado');
        box.erase();
        Get.offAllNamed('/login');
      } else {
        Get.defaultDialog(
          title: "Error",
          content: const Text('erro'),
        );
      }
    } catch (err) {
      Get.defaultDialog(
        title: "Erro",
        content: Text("$err"),
      );
    }
    return null;
  }
}
