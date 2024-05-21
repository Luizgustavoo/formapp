import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class AuthApiClient {
  final http.Client httpClient = http.Client();

  Future<Map<String, dynamic>?> getLogin(
      String username, String password) async {
    var loginUrl = Uri.parse('$baseUrl/login');
    try {
      var response = await httpClient
          .post(loginUrl, body: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        print('Erro de autenticação: Usuário ou senha inválidos');
      } else {
        print('Erro - get:${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getSignUp(
      String nome, String username, String senha) async {
    var signUpUrl = Uri.parse('$baseUrl/register');
    try {
      var response = await httpClient.post(signUpUrl, headers: {
        "Accept": "application/json",
      }, body: {
        'nome': nome,
        'username': username,
        'senha': senha
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        print('Falha: E-mail já cadastrado!');
      } else {
        print('Erro - get:${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLogout() async {
    var loginUrl = Uri.parse('$baseUrl/v1/logout');
    try {
      var response = await httpClient.post(
        loginUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${UserStorage.getToken()}",
        },
      );
      if (response.statusCode == 200) {
        UserStorage.clearBox();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> forgotPassword(String username) async {
    var forgotUrl = Uri.parse('$baseUrl/forgot-password');
    try {
      var response = await httpClient.post(forgotUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${UserStorage.getToken()}",
      }, body: {
        'username': username
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  insertPeople(People pessoa) async {
    try {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (isConnected) {
        var pessoaUrl = Uri.parse('$baseUrl/create-people');

        var request = http.MultipartRequest('POST', pessoaUrl);

        request.fields.addAll({
          "nome": pessoa.nome!,
          "sexo": pessoa.sexo!,
          "estadocivil_id": pessoa.estadoCivilId.toString(),
          "data_nascimento": pessoa.dataNascimento!,
          "cpf": pessoa.cpf!,
          "telefone": pessoa.telefone!,
          "rede_social": pessoa.redeSocial!,
          "titulo_eleitor": pessoa.tituloEleitor!,
          "zona_eleitoral": pessoa.zonaEleitoral!,
          "religiao_id": pessoa.religiaoId.toString(),
          "igreja_id": pessoa.igrejaId.toString(),
          "funcao_igreja": pessoa.funcaoIgreja!,
          "local_trabalho": pessoa.localTrabalho!,
          "cargo_trabalho": pessoa.cargoTrabalho!,
          "status": pessoa.status.toString(),
          "usuario_id": pessoa.usuarioId.toString(),
          "username": pessoa.username.toString(),
          "senha": pessoa.senha.toString()
        });

        request.headers.addAll({
          'Accept': 'application/json',
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
        Map<String, dynamic> responseData = {};

        responseData = {
          'code': 1,
          'message': 'Sem conexão com a internet!',
        };

        String jsonResponse = jsonEncode(responseData);

        return json.decode(jsonResponse);
      }
    } catch (err) {
      ErrorHandler.showError(err);
    }
    return null;
  }

  getLeader() async {
    try {
      var liderUrl = Uri.parse('$baseUrl/list-lider');
      var response = await httpClient.get(
        liderUrl,
        headers: {
          "Accept": "application/json",
        },
      );
      print(json.decode(response.body));
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  getMaritalStatus() async {
    try {
      var maritalUrl = Uri.parse('$baseUrl/list-marital-status');
      var response = await httpClient.get(
        maritalUrl,
        headers: {
          "Accept": "application/json",
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  getReligion() async {
    try {
      var religionUrl = Uri.parse('$baseUrl/list-religion');
      var response = await httpClient.get(
        religionUrl,
        headers: {
          "Accept": "application/json",
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  getChurch() async {
    try {
      var churchUrl = Uri.parse('$baseUrl/list-church');
      var response = await httpClient.get(
        churchUrl,
        headers: {
          "Accept": "application/json",
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
      ErrorHandler.showError(err);
    }
    return null;
  }
}
