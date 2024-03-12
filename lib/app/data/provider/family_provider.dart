import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/family_database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:formapp/app/utils/local_storage_service.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FamilyApiClient {
  final http.Client httpClient = http.Client();
  final FamilyDatabaseHelper localDataBase = FamilyDatabaseHelper();
  final box = GetStorage('credenciado');

  getAll(String token) async {
    final id = box.read('auth')['user']['id'];
    final familiaId = box.read('auth')['user']['familia_id'];
    try {
      Uri familyUrl;

      if (UserStorage.getUserType() == 1) {
        familyUrl = Uri.parse('$baseUrl/v1/familia/list/');
      } else if (UserStorage.getUserType() == 2) {
        familyUrl = Uri.parse('$baseUrl/v1/familia/list/id/$id');
      } else {
        familyUrl =
            Uri.parse('$baseUrl/v1/familia/list-familiar/id/$familiaId');
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
      Get.snackbar(
        'Sem Conexão',
        'Você está sem conexão com a internet.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 1500),
        isDismissible: true,
        overlayBlur: 0,
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Fechar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return null;
  }

  insertFamily(String token, Family family) async {
    try {
      if (await ConnectionStatus.verifyConnection()) {
        //SALVANDO DADOS NA API
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
      } else {
        //SALVANDO DADOS LOCALMENTE

        final dbHelper = DatabaseHelper();
        dynamic retorno = await dbHelper.insertFamily(family);

        print(retorno);

        Map<String, dynamic> responseData = {};

        if (retorno > 0) {
          responseData = {
            'message': 'success',
            'objeto': family,
          };
        } else {
          responseData = {
            'code': 0,
            'message': 'Operação realizada com sucesso',
          };
        }

        // Converter o mapa em uma string JSON
        String jsonResponse = jsonEncode(responseData);

        return json.decode(jsonResponse);
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
        title: "Erro",
        content: Text("$err"),
      );
    }
    return null;
  }

  deleteFamily(String token, Family family) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/delete/${family.id}');

      var response = await httpClient.delete(
        familyUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
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

  Future<List<Family>> getAllFamiliesLocally() async {
    return await localDataBase.getAllFamily();
  }

  Future<dynamic> saveFamilyLocal(Family family) async {
    Family familyLocal = Family(
      nome: family.nome,
      endereco: family.endereco,
      numeroCasa: family.numeroCasa,
      bairro: family.bairro,
      cidade: family.cidade,
      uf: family.uf,
      complemento: family.complemento,
      residenciaPropria: family.residenciaPropria,
      usuarioId: family.usuarioId,
      status: family.status,
      cep: family.cep,
      dataCadastro: '2024-02-22',
      dataUpdate: '2024-02-23',
    );

    return await localDataBase.insertFamily(familyLocal);
  }

  Future<void> deleteFamilyLocally(Family family) async {
    try {
      if (family.id != null) {
        //await localDatabase.delete(family.id!, 'family_table');
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
