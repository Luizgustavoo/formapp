import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/family_database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FamilyApiClient {
  final http.Client httpClient = http.Client();
  final FamilyDatabaseHelper localDataBase = FamilyDatabaseHelper();
  final box = GetStorage('credenciado');

  getAll(String token, {int? page}) async {
    final id = box.read('auth')['user']['id'];
    final familiaId = box.read('auth')['user']['familia_id'];
    try {
      Uri familyUrl;

      if (UserStorage.getUserType() == 1) {
        familyUrl =
            Uri.parse('$baseUrl/v1/familia/list-paginate/?page=$page&limit');
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

  insertFamily(String token, Family family, bool familyLocal) async {
    try {
      if (await ConnectionStatus.verifyConnection() && !familyLocal) {
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

  updateFamily(String token, Family family, bool familyLocal) async {
    try {
      if (await ConnectionStatus.verifyConnection() && !familyLocal) {
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
      } else {
        //update family local
        final dbHelper = DatabaseHelper();
        dynamic retorno = await dbHelper.updateFamily(family);

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
        title: "Erro",
        content: Text("$err"),
      );
    }
    return null;
  }

  deleteFamily(String token, Family family, bool familyLocal) async {
    try {
      if (await ConnectionStatus.verifyConnection() && !familyLocal) {
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
      } else {
        //remover offline
        final dbHelper = DatabaseHelper();
        dynamic retorno = await dbHelper.deleteFamilyAndPeople(family.id!);

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
      throw Exception('Erro ao buscar dados: $err');
    }
    return null;
  }

  Future<List<Family>> getAllFamiliesLocally() async {
    return await localDataBase.getAllFamily();
  }

  Future<Map<String, dynamic>> insertFamilyLocalForApi(
      String token, Family? family) async {
    var pessoaUrl = Uri.parse('$baseUrl/v1/familia/create-api-to-local');

    var request = http.MultipartRequest('POST', pessoaUrl);

    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    });

    // Adiciona informações da família
    request.fields.addAll({
      "nome": family!.nome!,
      "cep": family.cep!,
      "endereco": family.endereco!,
      "numero_casa": family.numeroCasa!,
      "bairro": family.bairro!,
      "cidade": family.cidade!,
      "uf": family.uf!,
      "complemento": family.complemento!,
      "residencia_propria": family.residenciaPropria!,
      "status": family.status.toString(),
      "usuario_id": family.usuarioId.toString(),
    });

    // Lista de mapas para representar pessoas
    List<Map<String, dynamic>> peopleList = [];

    // Adiciona informações de cada pessoa na família
    for (var person in family.pessoas!) {
      String uniqueNumericId = generateNumericUniqueId(8);
      // Mapa representando a pessoa
      Map<String, dynamic> personData = {
        "nome": person.nome!,
        "sexo": person.sexo!,
        "cpf": person.cpf!,
        "data_nascimento": person.dataNascimento!,
        "estadocivil_id": person.estadoCivilId.toString(),
        "titulo_eleitor": person.tituloEleitor!,
        "zona_eleitoral": person.zonaEleitoral!,
        "telefone": person.telefone!,
        "rede_social": person.redeSocial!,
        "provedor_casa": person.provedorCasa!,
        "igreja_id": person.igrejaId.toString(),
        "local_trabalho": person.localTrabalho!,
        "cargo_trabalho": person.cargoTrabalho!,
        "religiao_id": person.religiaoId.toString(),
        "funcao_igreja": person.funcaoIgreja!,
        "usuario_id": person.usuarioId.toString(),
        "status": person.status.toString(),
        "familia_id": person.familiaId.toString(),
        "parentesco": person.parentesco!,
        "codigo_unico": uniqueNumericId
      };

      // Adiciona o mapa da pessoa à lista
      peopleList.add(personData);

      // Adiciona a foto da pessoa, se existir
      if (person.foto != null && person.foto is String) {
        File imageFile = File(person.foto!);
        if (imageFile.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath(
            uniqueNumericId, // Nome do campo que a API espera para a imagem (com identificador único)
            imageFile.path, // Caminho do arquivo da imagem
          ));
        } else {
          throw Exception('Arquivo de imagem não encontrado: ${person.foto}');
        }
      }
    }

    // Converta a lista de pessoas em JSON e adicione aos dados da família
    request.fields['pessoas'] = json.encode(peopleList);

    var response = await request.send();

    var responseStream = await response.stream.bytesToString();
    var httpResponse = http.Response(responseStream, response.statusCode);

    if (response.statusCode == 200) {
      return json.decode(httpResponse.body.toString());
    } else {
      Map<String, dynamic> responseData = {};

      responseData = {
        'code': 1,
        'message': 'error',
      };

      return responseData;
    }
  }

  String generateNumericUniqueId(int length) {
    final random = Random();
    final max = pow(10, length).toInt();
    final uniqueId = random.nextInt(max);
    return uniqueId.toString().padLeft(length, '0');
  }
}
