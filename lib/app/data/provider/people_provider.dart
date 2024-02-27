import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PeopleApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();

  getAll(String token) async {
    try {
      var peopleUrl = Uri.parse('$baseUrl/v1/pessoa/list');
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

  insertPeople(String token, People pessoa, File imageFile) async {
    try {
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
          'foto', // Nome do campo que a API espera para a imagem
          imageFile.path, // Caminho do arquivo da imagem
        ));
      }

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
        // Adicione outros cabeçalhos conforme necessário
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

  updatePeople(
      String token, People pessoa, File imageFile, String? oldImagePath) async {
    try {
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
          'foto', // Nome do campo que a API espera para a imagem
          imageFile.path, // Caminho do arquivo da imagem
        ));
      }

      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        'Accept': 'application/json',
        'Authorization': token,
        // Adicione outros cabeçalhos conforme necessário
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

  /*SALVAR DADOS OFFLINE DA PESSOA */
  Future<void> savePeopleLocally(Map<String, dynamic> peopleData) async {
    await localDatabase.insert(peopleData, 'people_table');
  }

  Future<List<Map<String, dynamic>>> getAllPeopleLocally() async {
    return await localDatabase.getAllDataLocal('people_table');
  }

  Future<void> savePeopleLocal(People people) async {
    final peopleData = {
      'nome': people.nome,
      'foto': people.foto,
      'sexo': people.sexo,
      'cpf': people.cpf,
      'data_nascimento': people.dataNascimento,
      'estadocivil_id': people.estadoCivilId,
      'titulo_eleitor': people.tituloEleitor,
      'zona_eleitoral': people.zonaEleitoral,
      'telefone': people.telefone,
      'rede_social': people.redeSocial,
      'provedor_casa': people.provedorCasa,
      'igreja_id': people.igrejaId,
      'local_trabalho': people.localTrabalho,
      'cargo_trabalho': people.cargoTrabalho,
      'religiao_id': people.religiaoId,
      'funcao_igreja': people.funcaoIgreja,
      'usuario_id': people.usuarioId,
      'status': people.status,
      'data_cadastro': people.dataCadastro,
      'data_update': people.dataUpdate,
      'familia_id': people.familiaId,
      'parentesco': people.parentesco,
    };

    await savePeopleLocally(peopleData);
  }
}
