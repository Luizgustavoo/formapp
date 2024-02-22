import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FamilyApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();

  getAll(String token) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/list');
      var response = await httpClient.get(
        familyUrl,
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

  insertFamily(String token, Family family) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/create');

      var requestBody = {
        // Adicione aqui os campos necessários conforme esperado pela sua API
        "nome": family.nome,
        "cep": family.cep,
        "endereco": family.endereco,
        "numero_casa": family.numero_casa,
        "bairro": family.bairro,
        "cidade": family.cidade,
        "uf": family.uf,
        "complemento": family.complemento,
        "residencia_propria": family.residencia_propria,
        "status": family.status.toString(),
        "usuario_id": family.usuario_id.toString(),

        // Adicione os demais campos conforme necessário
      };

      // print(requestBody);
      // return;

      var response = await httpClient.post(
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
        print(json.decode(response.body));

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

  updateFamily(String token, Family family) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/update/${family.id}');

      var requestBody = {
        // Adicione aqui os campos necessários conforme esperado pela sua API
        "nome": family.nome,
        "cep": family.cep,
        "endereco": family.endereco,
        "numero_casa": family.numero_casa,
        "bairro": family.bairro,
        "cidade": family.cidade,
        "uf": family.uf,
        "complemento": family.complemento,
        "residencia_propria": family.residencia_propria,
        "status": family.status.toString(),
        "usuario_id": family.usuario_id.toString(),

        // Adicione os demais campos conforme necessário
      };

      var response = await httpClient.put(
        familyUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
        body: requestBody,
      );
      print('response body: ');
      print(json.decode(response.body));
      print('-----FIMMMM-----');

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

  /*SALVAR DADOS OFFLINE DA FAMILIA */
  Future<void> saveFamilyLocally(Map<String, dynamic> familyData) async {
    await localDatabase.insert(familyData, 'family_table');
  }

  Future<List<Map<String, dynamic>>> getAllFamiliesLocally() async {
    return await localDatabase.getAllDataLocal('family_table');
  }

  Future<void> saveFamilyLocal(Family family) async {
    final familyData = {
      'nome': family.nome,
      'endereco': family.endereco,
      'numero_casa': family.numero_casa,
      'bairro': family.bairro,
      'cidade': family.cidade,
      'uf': family.uf,
      'complemento': family.complemento,
      'residencia_propria': family.residencia_propria,
      'usuario_id': family.usuario_id,
      'status': family.status,
      'cep': family.cep,
      'data_cadastro': '2024-02-22',
      'data_update': '2024-02-23',
    };

    // Se não houver conectividade, salva localmente
    await saveFamilyLocally(familyData);
  }
}
