import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MessageApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();
  final box = GetStorage('credenciado');

  insertMessage(String token, Family family, Message message) async {
    final id = box.read('auth')['user']['id'];
    try {
      var messageUrl = Uri.parse('$baseUrl/v1/mensagem/create');

      //final List<Map<String, dynamic>> pessoasJson =
      // family.pessoas!.map((pessoa) => pessoa.toJson()).toList();

      final List<Map<String, dynamic>> pessoasJson =
          family.pessoas!.map((pessoa) => pessoa.toJson()).toList();

      var requestBody = {
        "data": message.data.toString(),
        "titulo": message.titulo,
        "descricao": message.descricao,
        "usuario_id": id.toString(),
        "pessoas": jsonEncode(pessoasJson),
      };

      var response = await httpClient.post(
        messageUrl,
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

  /*SALVAR DADOS OFFLINE DA MENSAGEM */
  Future<void> saveMessageLocally(Map<String, dynamic> messageData) async {
    await localDatabase.insert(messageData, 'message_table');
  }

  Future<List<Map<String, dynamic>>> getAllMessageLocally() async {
    return await localDatabase.getAllDataLocal('message_table');
  }

  Future<void> saveMessageLocal(Message message) async {
    final messageData = {
      'data': message.data,
      'titulo': message.titulo,
      'descricao': message.descricao,
      'usuario_id': message.usuarioId,
      'data_cadastro': message.dataCadastro,
      'data_update': message.dataUpdate,
    };

    await saveMessageLocally(messageData);
  }
}
