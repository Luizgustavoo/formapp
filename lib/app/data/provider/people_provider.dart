import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PeopleApiClient {
  final http.Client httpClient = http.Client();

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

      // print(json.decode(httpResponse.body));
      print(response.statusCode);

      if (response.statusCode == 200) {
        return json.decode(httpResponse.body);
      } else if (response.statusCode == 422 ||
          json.decode(httpResponse.body)['message'] == "ja_existe") {
        print(json.decode(httpResponse.body));

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
    print('$baseUrl/v1/pessoa/update/${pessoa.id}');
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

      print(json.decode(httpResponse.body));

      if (response.statusCode == 200) {
        return json.decode(httpResponse.body);
      } else if (response.statusCode == 422 ||
          json.decode(httpResponse.body)['message'] == "ja_existe") {
        print(json.decode(httpResponse.body));

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
}
