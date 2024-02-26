import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FamilyServiceApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();
  var serviceUrl = Uri.parse('$baseUrl/v1/atendimento/create');

  insertService(String token, FamilyService familyService) async {
    try {
      var requestBody = {
        "data_atendimento": familyService.dataAtendimento,
        "assunto": familyService.assunto,
        "descricao": familyService.descricao,
        "usuario_id": familyService.usuarioId.toString(),
        "pessoa_id": familyService.pessoaId.toString()
      };

      var response = await httpClient.post(
        serviceUrl,
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
        title: "Errorou",
        content: Text("$err"),
      );
    }
    return null;
  }

  updateService(String token, FamilyService familyService) async {
    try {
      var serviceUrlUpdate =
          Uri.parse('$baseUrl/v1/atendimento/update/${familyService.id}');

      var requestBody = {
        "data_atendimento": familyService.dataAtendimento,
        "assunto": familyService.assunto,
        "descricao": familyService.descricao,
        "usuario_id": familyService.usuarioId.toString(),
        "pessoa_id": familyService.pessoaId.toString()
      };

      var response = await httpClient.put(
        serviceUrlUpdate,
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

  /*SALVAR DADOS OFFLINE DO ATENDIMENTO */
  Future<void> saveFamilyServiceLocally(
      Map<String, dynamic> familyServiceData) async {
    await localDatabase.insert(familyServiceData, 'family_service_table');
  }

  Future<List<Map<String, dynamic>>> getAllFamilyServiceLocally() async {
    return await localDatabase.getAllDataLocal('family_service_table');
  }

  Future<void> saveFamilyServiceLocal(FamilyService familyService) async {
    final familyServiceData = {
      'data_atendimento': familyService.dataAtendimento,
      'assunto': familyService.assunto,
      'descricao': familyService.descricao,
      'usuario_id': familyService.usuarioId,
      'data_cadastro': familyService.dataCadastro,
      'data_update': familyService.dataUpdate,
      'pessoa_id': familyService.pessoaId,
    };
    await saveFamilyServiceLocally(familyServiceData);
  }
}
