import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/service_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/people_database_helper.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class PeopleApiClient {
  final http.Client httpClient = http.Client();
  final PeopleDatabaseHelper localDatabase = PeopleDatabaseHelper();
  final box = GetStorage('credenciado');

  Future<dynamic> getAll(String token, {int? page, String? search}) async {
    final userId = UserStorage.getUserId();
    final familiaId = UserStorage.getFamilyId();
    final userType = UserStorage.getUserType();
    try {
      Uri peopleUrl;

      String url =
          '$baseUrl/v1/pessoa/list/$userType/$search/$familiaId/$userId?page=$page';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> getAllMember(String token, int? familiaId) async {
    try {
      Uri peopleUrl;

      String url = '$baseUrl/v1/pessoa/list-familiar/id/$familiaId';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> getAllService(String token, int? peopleId) async {
    try {
      Uri peopleUrl;

      String url = '$baseUrl/v1/atendimentos/pessoa/$peopleId';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<void> deleteService(String token, int atendimentoId) async {
    try {
      final url = '$baseUrl/v1/atendimento/delete/$atendimentoId';
      final uri = Uri.parse(url);

      final response = await httpClient.delete(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        return;
      }

      if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        Get.defaultDialog(
          title: "Expirou",
          content: const Text(
            'O token de autenticação expirou, faça login novamente.',
          ),
        );
        final box = GetStorage('credenciado');
        box.erase();
        Get.offAllNamed('/login');
        return;
      }

      throw Exception(json.decode(response.body)['message']);
    } catch (e) {
      ErrorHandler.showError("Erro ao remover atendimento");
    }
  }

  Future<dynamic> getAllFilter(String token, {int? page, User? user}) async {
    try {
      Uri peopleUrl;

      String url =
          '$baseUrl/v1/pessoa/list-paginate-lider/${user!.id}/?page=$page&limit';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> insertPeople(
      String token,
      People pessoa,
      File imageFile,
      bool peopleLocal,
      List? saude,
      List? medicamento,
      String? email,
      String? senha) async {
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
        if (saude != null) {
          request.fields['saude'] = json.encode(saude);
        }
        if (medicamento != null) {
          request.fields['medicamento'] = json.encode(medicamento);
        }

        if (email != null) {
          request.fields['email'] = email;
        }

        if (senha != null) {
          request.fields['senha'] = senha;
        }

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  List<int> stringToIntList(String input) {
    List<String> stringList = input.split(',');
    List<int> intList = stringList.map(int.parse).toList();
    return intList;
  }

  Future<dynamic> updatePeople(
      String token,
      People pessoa,
      File imageFile,
      String? oldImagePath,
      bool peopleLocal,
      List? saude,
      List? medicamento) async {
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

        if (saude != null) {
          request.fields['saude'] = json.encode(saude);
        }
        if (medicamento != null) {
          request.fields['medicamento'] = json.encode(medicamento);
        }

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> changePeopleFamily(String token, People people) async {
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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> deletePeople(
      String token, People people, bool peopleLocal) async {
    try {
      if (await ConnectionStatus.verifyConnection() && !peopleLocal) {
        var peopleUrl = Uri.parse('$baseUrl/v1/pessoa/delete/${people.id}');

        var response = await httpClient.delete(
          peopleUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> deletePeopleLocal(People people) async {
    try {
      //remover offline
      final dbHelper = DatabaseHelper();
      dynamic retorno = await dbHelper.deletePeople(people.id!);

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

      String jsonResponse = jsonEncode(responseData);

      return json.decode(jsonResponse);
    } catch (err) {
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> getAllbyUser(String token) async {
    final userId = UserStorage.getUserId();
    try {
      Uri peopleUrl;

      String url = '$baseUrl/v1/pessoa/list/id/$userId';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> getAllCategories(String token) async {
    final userId = UserStorage.getUserId();
    try {
      Uri peopleUrl;

      String url = '$baseUrl/v1/categoriaatendimento/list';
      peopleUrl = Uri.parse(url);

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
      ErrorHandler.showError("Sem conexão!");
    }
    return null;
  }

  Future<dynamic> insertAtendimento(
      String token, Atendimento atendimento, List<File> imagens) async {
    try {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (!isConnected) {
        Get.defaultDialog(
            title: "Error", content: const Text('Sem conexão com a internet!'));
        return null;
      }

      var uri = Uri.parse('$baseUrl/v1/atendimento/create');

      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": token,
      });

      request.fields['data_atendimento'] =
          atendimento.dataAtendimento.toIso8601String();
      request.fields['observacoes'] = atendimento.observacoes ?? '';
      request.fields['usuario_id'] = atendimento.usuarioId.toString();
      request.fields['pessoa_id'] = atendimento.pessoaId.toString();
      request.fields['categoria_id'] = atendimento.categoriaId.toString();

      /// 📸 ADICIONA IMAGENS
      for (var img in imagens) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'imagens[]', // backend deve esperar array
            img.path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        Get.defaultDialog(
            title: "Error", content: Text('Erro ${response.statusCode}'));
      }
    } catch (err) {
      ErrorHandler.showError("Erro ao enviar atendimento com imagens");
    }

    return null;
  }

  Future<dynamic> updateAtendimento(
    String token,
    Atendimento atendimento,
    List<File> novasImagens,
    List<int> removerImagensIds,
  ) async {
    try {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (!isConnected) {
        Get.defaultDialog(
            title: "Error", content: const Text('Sem conexão com a internet!'));
        return null;
      }

      var uri = Uri.parse('$baseUrl/v1/atendimento/update/${atendimento.id}');
      var request = http.MultipartRequest(
          'POST', uri); // PATCH multipart é ruim, usar POST

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": token,
      });

      request.fields['_method'] = 'PATCH'; // Laravel entende como PATCH

      request.fields['data_atendimento'] =
          atendimento.dataAtendimento.toIso8601String();
      request.fields['observacoes'] = atendimento.observacoes ?? '';
      request.fields['usuario_id'] = atendimento.usuarioId.toString();
      request.fields['pessoa_id'] = atendimento.pessoaId.toString();
      request.fields['categoria_id'] = atendimento.categoriaId.toString();

      /// 🗑 IDS DE IMAGENS PARA REMOVER
      for (var id in removerImagensIds) {
        request.fields['remover_imagens[]'] = id.toString();
      }

      /// 📸 NOVAS IMAGENS
      for (var img in novasImagens) {
        request.files.add(
          await http.MultipartFile.fromPath('imagens[]', img.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Get.defaultDialog(
            title: "Error", content: Text('Erro ${response.statusCode}'));
      }
    } catch (err) {
      ErrorHandler.showError("Erro ao atualizar atendimento");
    }

    return null;
  }
}
