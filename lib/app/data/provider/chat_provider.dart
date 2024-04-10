import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';

class ChatApiClient {
  final http.Client httpClient = http.Client();

  getAll(String token, int remententeId, int destinatarioId) async {
    try {
      var chatUrl = Uri.parse('$baseUrl/v1/chat/list');
      var response = await httpClient.post(chatUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "remetente_id": remententeId.toString(),
        "destinatario_id": destinatarioId.toString()
      });

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
      throw Exception('Erro ao buscar dados: $err');
    }
    return null;
  }
}
