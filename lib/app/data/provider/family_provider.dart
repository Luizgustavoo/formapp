import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/family_database_helper.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class FamilyApiClient {
  final http.Client httpClient = http.Client();
  final FamilyDatabaseHelper localDataBase = FamilyDatabaseHelper();
  final box = GetStorage('credenciado');

  getAll(String token, {int? page, String? search}) async {
    final id = box.read('auth')['user']['id'];
    final familiaId = UserStorage.getFamilyId();
    try {
      Uri familyUrl;

      if (UserStorage.getUserType() == 1) {
        String url = search != null
            ? '$baseUrl/v1/familia/list-paginate/$search/'
            : '$baseUrl/v1/familia/list-paginate/';
        familyUrl = Uri.parse(url);
      } else if (UserStorage.getUserType() == 2) {
        String url = search != null
            ? '$baseUrl/v1/familia/list-paginate/id/$id/$search/?page=$page&limit'
            : '$baseUrl/v1/familia/list-paginate/id/$id/?page=$page&limit';

        familyUrl = Uri.parse(url);
      } else {
        String url = search != null
            ? '$baseUrl/v1/familia/list-familiar-paginate/id/$familiaId/$search/?page=$page&limit'
            : '$baseUrl/v1/familia/list-familiar-paginate/id/$familiaId/?page=$page&limit';

        familyUrl = Uri.parse(url);
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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  getAllFilter(String token, {int? page, User? user}) async {
    try {
      Uri familyUrl;
      String url =
          '$baseUrl/v1/familia/list-paginate-lider/null/${user!.id}/?page=$page&limit';
      familyUrl = Uri.parse(url);

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
      }
    } catch (err) {
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  //*APENAS PARA O DROPDOWN*/
  getAllDropDown(String token) async {
    try {
      Uri familyUrl = Uri.parse('$baseUrl/v1/familia/list');

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  insertFamily(String token, Family family) async {
    try {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (isConnected) {
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
      ErrorHandler.showError("Sem conexão!");
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
      ErrorHandler.showError("Sem conexão!");
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
        dynamic retorno = await dbHelper.deleFamily(family.id!);

        Map<String, dynamic> responseData = {};

        if (retorno > 0) {
          responseData = {
            'code': 0,
            'message': 'Operação realizada com sucesso!',
          };
        } else {
          responseData = {
            'code': 1,
            'message': 'Falha ao realizar a operação!',
          };
        }

        // Converter o mapa em uma string JSON
        String jsonResponse = jsonEncode(responseData);

        return json.decode(jsonResponse);
      }
    } catch (err) {
      ErrorHandler.showError("Sem conexão!");
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
          ErrorHandler.showError("Arquivo de imagem não encontrado!");
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
