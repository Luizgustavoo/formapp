import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';

class MessageApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();
  final box = GetStorage('credenciado');

  getAll(String token) async {
    final id = box.read('auth')['user']['id'];

    try {
      var messageUrl = Uri.parse('$baseUrl/v1/mensagem/list/$id');

      var response = await httpClient.get(
        messageUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError('Sem Conexão');
    }
    return null;
  }

  getAllUnreadMessage(String token) async {
    final id = box.read('auth')['user']['id'];

    try {
      var messageUrl = Uri.parse('$baseUrl/v1/chat/unread/$id');

      var response = await httpClient.get(
        messageUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError('Sem Conexão');
    }
    return null;
  }

  insertMessage(
      String token, Family? family, Message message, User? user) async {
    final id = UserStorage.getUserId();
    try {
      var messageUrl = Uri.parse('$baseUrl/v1/mensagem/create');

      var requestBody = {
        "titulo": message.titulo,
        "descricao": message.descricao,
        "usuario_remetente": id.toString(),
      };
      if (user != null) {
        requestBody['usuario_destinatario'] = user.id.toString();
        requestBody['token_firebase'] = user.tokenFirebase;
      }
      if (family != null) {
        requestBody['familia_id'] = family.id.toString();
      }
      var response = await httpClient.post(
        messageUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError(err);
    }
    return null;
  }

  messageChange(String token, int messageId, int userId) async {
    try {
      var messageUrl = Uri.parse('$baseUrl/v1/mensagem/change');

      var requestBody = {
        "usuario_id": userId.toString(),
        "mensagem_id": messageId.toString(),
      };

      var response = await httpClient.post(
        messageUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError(err);
    }
    return null;
  }
}
