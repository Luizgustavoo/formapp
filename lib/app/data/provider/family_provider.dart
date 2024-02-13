import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FamilyApiClient {
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

  insert(String token, Family family) async {
    try {
      var familyUrl = Uri.parse('$baseUrl/v1/familia/create');

      List<Map<String, dynamic>> pessoasData = [];

      print(family.pessoas![0].nome);
      return;

      for (Pessoas pessoa in family.pessoas!) {
        var pessoaMap = {
          "nome": pessoa.nome,
          "foto": pessoa.foto,
          "sexo": pessoa.sexo,
          "cpf": pessoa.cpf,
          "data_nascimento": pessoa.data_nascimento,
          "titulo_eleitor": pessoa.titulo_eleitor,
          "zona_eleitoral": pessoa.zona_eleitoral,
          "telefone": pessoa.telefone,
          "rede_social": pessoa.rede_social,
          "provedor_casa": pessoa.provedor_casa,
          "igreja_id": pessoa.igreja_id,
          "local_trabalho": pessoa.local_trabalho,
          "cargo_trabalho": pessoa.cargo_trabalho,
          "religiao_id": pessoa.religiao_id,
          "funcao_igreja": pessoa.funcao_igreja,
          "status": pessoa.status,
          "estadocivil_id": pessoa.estadocivil_id
        };
        pessoasData.add(pessoaMap);
      }

      var requestBody = {
        // Adicione aqui os campos necessários conforme esperado pela sua API
        "nome": family.nome,
        "endereco": family.endereco,
        "numero_casa": family.numero_casa,
        "bairro": family.bairro,
        "cidade": family.cidade,
        "uf": family.uf,
        "complemento": family.complemento,
        "residencia_propria": family.residencia_propria,
        "observacoes": family.obs,
        "status": family.status,
        "usuario_id": family.usuario_id,
        'pessoas': pessoasData,
        // Adicione os demais campos conforme necessário
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
}
