import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/people_database_helper.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/user_storage.dart';

class PeopleApiClient {
  final http.Client httpClient = http.Client();
  final PeopleDatabaseHelper localDatabase = PeopleDatabaseHelper();
  final box = GetStorage('credenciado');

  getAll(String token, {int? page}) async {
    final id = UserStorage.getUserId();
    final familiaId = box.read('auth')['user']['familia_id'];
    try {
      Uri peopleUrl;
      if (familiaId != null) {
        peopleUrl = Uri.parse(
            '$baseUrl/v1/pessoa/list-familiar-paginate/id/$familiaId/?page=1&limit');
      } else {
        peopleUrl = Uri.parse(
            '$baseUrl/v1/pessoa/list-paginate/id/$id/?page=$page&limit');
      }

      var response = await httpClient.get(
        peopleUrl,
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

  insertPeople(
      String token, People pessoa, File imageFile, bool peopleLocal) async {
    try {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (isConnected && !peopleLocal) {
        var pessoaUrl = Uri.parse('$baseUrl/v1/pessoa/create');

        var request = http.MultipartRequest('POST', pessoaUrl);

        request.fields.addAll({
          "nome": pessoa.nome!,
          "sexo": pessoa.sexo!,
          "cpf": pessoa.cpf!,
          "data_nascimento": pessoa.dataNascimento!,
          "estadocivil_id": pessoa.estadoCivilId.toString(),
          "titulo_eleitor": pessoa.tituloEleitor!,
          "zona_eleitoral": pessoa.zonaEleitoral!,
          "telefone": pessoa.telefone!,
          "rede_social": pessoa.redeSocial!,
          "provedor_casa": pessoa.provedorCasa!,
          "igreja_id": pessoa.igrejaId.toString(),
          "local_trabalho": pessoa.localTrabalho!,
          "cargo_trabalho": pessoa.cargoTrabalho!,
          "religiao_id": pessoa.religiaoId.toString(),
          "funcao_igreja": pessoa.funcaoIgreja!,
          "usuario_id": pessoa.usuarioId.toString(),
          "status": pessoa.status.toString(),
          "familia_id": pessoa.familiaId.toString(),
          "parentesco": pessoa.parentesco!,
        });

        if (imageFile.path.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
            'foto',
            imageFile.path,
          ));
        }

        request.headers.addAll({
          'Accept': 'application/json',
          'Authorization': token,
        });

        var response = await request.send();

        var responseStream = await response.stream.bytesToString();
        var httpResponse = http.Response(responseStream, response.statusCode);

        print(json.decode(httpResponse.body));

        if (response.statusCode == 200) {
          return json.decode(httpResponse.body);
        } else if (response.statusCode == 422 ||
            json.decode(httpResponse.body)['message'] == "ja_existe") {
          return json.decode(httpResponse.body);
        } else if (response.statusCode == 401 &&
            json.decode(httpResponse.body)['message'] == "Token has expired") {
          Get.defaultDialog(
            title: "Expirou",
            content: const Text(
                'O token de autenticação expirou, faça login novamente.'),
          );
          var box = GetStorage('credenciado');
          box.erase();
          Get.offAllNamed('/login');
        }
      } else {
        final dbHelper = DatabaseHelper();
        dynamic retorno = await dbHelper.insertPeople(pessoa);

        Map<String, dynamic> responseData = {};

        if (retorno > 0) {
          responseData = {
            'message': 'success',
            'objeto': pessoa,
          };
        } else {
          responseData = {
            'code': 0,
            'message': 'Operação realizada com sucesso',
          };
        }

        String jsonResponse = jsonEncode(responseData);

        return json.decode(jsonResponse);
      }
    } catch (err) {
      throw Exception("$err");
    }
    return null;
  }

  updatePeople(String token, People pessoa, File imageFile,
      String? oldImagePath, bool peopleLocal) async {
    try {
      if (await ConnectionStatus.verifyConnection() && !peopleLocal) {
        var pessoaUrl = Uri.parse('$baseUrl/v1/pessoa/update/${pessoa.id}');

        var request = http.MultipartRequest('POST', pessoaUrl);

        request.fields.addAll({
          "nome": pessoa.nome!,
          "sexo": pessoa.sexo!,
          "cpf": pessoa.cpf!,
          "data_nascimento": pessoa.dataNascimento!,
          "estadocivil_id": pessoa.estadoCivilId.toString(),
          "titulo_eleitor": pessoa.tituloEleitor!,
          "zona_eleitoral": pessoa.zonaEleitoral!,
          "telefone": pessoa.telefone!,
          "rede_social": pessoa.redeSocial!,
          "provedor_casa": pessoa.provedorCasa!,
          "igreja_id": pessoa.igrejaId.toString(),
          "local_trabalho": pessoa.localTrabalho!,
          "cargo_trabalho": pessoa.cargoTrabalho!,
          "religiao_id": pessoa.religiaoId.toString(),
          "funcao_igreja": pessoa.funcaoIgreja!,
          "usuario_id": pessoa.usuarioId.toString(),
          "status": pessoa.status.toString(),
          "familia_id": pessoa.familiaId.toString(),
          "parentesco": pessoa.parentesco!,
        });

        if (imageFile.path.isNotEmpty && imageFile.path != oldImagePath) {
          request.files.add(await http.MultipartFile.fromPath(
            'foto',
            imageFile.path,
          ));
        }

        request.headers.addAll({
          "Content-Type": "multipart/form-data",
          'Accept': 'application/json',
          'Authorization': token,
        });

        var response = await request.send();

        var responseStream = await response.stream.bytesToString();
        var httpResponse = http.Response(responseStream, response.statusCode);

        if (response.statusCode == 200) {
          return json.decode(httpResponse.body);
        } else if (response.statusCode == 422 ||
            json.decode(httpResponse.body)['message'] == "ja_existe") {
          return json.decode(httpResponse.body);
        } else if (response.statusCode == 401 &&
            json.decode(httpResponse.body)['message'] == "Token has expired") {
          Get.defaultDialog(
            title: "Expirou",
            content: const Text(
                'O token de autenticação expirou, faça login novamente.'),
          );
          var box = GetStorage('credenciado');
          box.erase();
          Get.offAllNamed('/login');
        }
      } else {
        final dbHelper = DatabaseHelper();
        dynamic retorno = await dbHelper.updatePeople(pessoa);

        Map<String, dynamic> responseData = {};

        if (retorno > 0) {
          responseData = {
            'message': 'success',
            'objeto': pessoa,
          };
        } else {
          responseData = {
            'code': 0,
            'message': 'Operação realizada com sucesso',
          };
        }

        String jsonResponse = jsonEncode(responseData);

        return json.decode(jsonResponse);
      }
    } catch (err) {
      throw Exception("$err");
    }
    return null;
  }

  changePeopleFamily(String token, People people) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/pessoa/change/${people.id}');

      var requestBody = {
        "familia_id": people.familiaId.toString(),
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
      }
    } catch (err) {
      throw Exception("$err");
    }
    return null;
  }

  Future<List<People>> getAllPeopleLocally() async {
    return await localDatabase.getAllPeople();
  }

  Future<dynamic> savePeopleLocal(People people) async {
    People peopleData = People(
      nome: people.nome,
      foto: people.foto,
      sexo: people.sexo,
      cpf: people.cpf,
      dataNascimento: people.dataNascimento,
      estadoCivilId: people.estadoCivilId,
      tituloEleitor: people.tituloEleitor,
      zonaEleitoral: people.zonaEleitoral,
      telefone: people.telefone,
      redeSocial: people.redeSocial,
      provedorCasa: people.provedorCasa,
      igrejaId: people.igrejaId,
      localTrabalho: people.localTrabalho,
      cargoTrabalho: people.cargoTrabalho,
      religiaoId: people.religiaoId,
      funcaoIgreja: people.funcaoIgreja,
      usuarioId: people.usuarioId,
      status: people.status,
      dataCadastro: people.dataCadastro,
      dataUpdate: people.dataUpdate,
      familiaId: people.familiaId,
      parentesco: people.parentesco,
    );

    return await localDatabase.insertPeople(peopleData);
  }
}
