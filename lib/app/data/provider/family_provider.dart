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
  final box = GetStorage('credenciado');

  getAll(String token) async {
    final id = box.read('auth')['user']['id'];
    final familiaId = box.read('auth')['user']['familia_id'];
    try {
      Uri familyUrl;
      if (familiaId != null) {
        familyUrl =
            Uri.parse('$baseUrl/v1/familia/list-familiar/id/$familiaId');
      } else {
        familyUrl = Uri.parse('$baseUrl/v1/familia/list/id/$id');
      }

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
        "nome": family.nome,
        "cep": family.cep,
        "endereco": family.endereco,
        "numero_casa": family.numeroCasa,
        "bairro": family.bairro,
        "cidade": family.cidade,
        "uf": family.uf,
        "complemento": family.complemento,
        "residencia_propria": family.residenciaPropria,
        "status": family.status.toString(),
        "usuario_id": family.usuarioId.toString(),
      };

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
        "nome": family.nome,
        "cep": family.cep,
        "endereco": family.endereco,
        "numero_casa": family.numeroCasa,
        "bairro": family.bairro,
        "cidade": family.cidade,
        "uf": family.uf,
        "complemento": family.complemento,
        "residencia_propria": family.residenciaPropria,
        "status": family.status.toString(),
        "usuario_id": family.usuarioId.toString(),
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

  Future<dynamic> saveFamilyLocally(Map<String, dynamic> familyData) async {
    var retorno = await localDatabase.insert(familyData, 'family_table');
    return retorno;
  }

  Future<List<Map<String, dynamic>>> getAllFamiliesLocally() async {
    return await localDatabase.getAllDataLocal('family_table');
  }

  Future<dynamic> saveFamilyLocal(Family family) async {
    final familyData = {
      'nome': family.nome,
      'endereco': family.endereco,
      'numero_casa': family.numeroCasa,
      'bairro': family.bairro,
      'cidade': family.cidade,
      'uf': family.uf,
      'complemento': family.complemento,
      'residencia_propria': family.residenciaPropria,
      'usuario_id': family.usuarioId,
      'status': family.status,
      'cep': family.cep,
      'data_cadastro': '2024-02-22',
      'data_update': '2024-02-23',
    };

    return await saveFamilyLocally(familyData);
  }

  Future<void> deleteFamilyLocally(Family family) async {
    try {
      if (family.id != null) {
        await localDatabase.delete(family.id!, 'family_table');
        print('Família excluída localmente com sucesso');
      } else {
        print('ID da família é nulo. Não é possível excluir.');
      }
    } catch (e) {
      print('Erro ao excluir família localmente: $e');
      rethrow;
    }
  }
}
