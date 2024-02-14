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
        "status": family.status.toString(),
        "usuario_id": family.usuario_id.toString(),

        // Adicione os demais campos conforme necessário
      };

      int x = 0;
      for (Pessoas pessoa in family.pessoas!) {
        requestBody["pessoa[$x][nome]"] = pessoa.nome ?? "";
        requestBody["pessoa[$x][foto]"] = pessoa.foto ?? "";
        requestBody["pessoa[$x][sexo]"] = pessoa.sexo ?? "";
        requestBody["pessoa[$x][cpf]"] = pessoa.cpf ?? "";
        requestBody["pessoa[$x][data_nascimento]"] =
            pessoa.data_nascimento ?? "";
        requestBody["pessoa[$x][titulo_eleitor]"] = pessoa.titulo_eleitor ?? "";
        requestBody["pessoa[$x][zona_eleitoral]"] = pessoa.zona_eleitoral ?? "";
        requestBody["pessoa[$x][telefone]"] = pessoa.telefone ?? "";
        requestBody["pessoa[$x][rede_social]"] = pessoa.rede_social ?? "";
        requestBody["pessoa[$x][provedor_casa]"] = pessoa.provedor_casa ?? "";
        requestBody["pessoa[$x][igreja_id]"] =
            pessoa.igreja_id.toString() ?? "";
        requestBody["pessoa[$x][local_trabalho]"] = pessoa.local_trabalho ?? "";
        requestBody["pessoa[$x][cargo_trabalho]"] = pessoa.cargo_trabalho ?? "";
        requestBody["pessoa[$x][religiao_id]"] =
            pessoa.religiao_id.toString() ?? "";
        requestBody["pessoa[$x][funcao_igreja]"] = pessoa.funcao_igreja ?? "";
        requestBody["pessoa[$x][status]"] = pessoa.status.toString() ?? "";
        requestBody["pessoa[$x][estadocivil_id]"] =
            pessoa.estadocivil_id.toString() ?? "";
        x++;
      }

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
