import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class UserApiClient {
  final http.Client httpClient = http.Client();
  final box = GetStorage('credenciado');

  getAll(String token, {int? page, String? search}) async {
    final id = UserStorage.getUserId();
    try {
      String url = search != null
          ? '$baseUrl/v1/usuario/list-paginate/$id/$search/?page=$page&limit'
          : '$baseUrl/v1/usuario/list-paginate/$id/?page=$page&limit';
      var userUrl = Uri.parse(url);
      var response = await httpClient.get(
        userUrl,
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
      //
    }
    return null;
  }

  insertUser(String token, User user) async {
    try {
      var userUrl = Uri.parse('$baseUrl/v1/usuario/create');

      var requestBody = {
        "nome": user.nome,
        "tipousuario_id": user.tipousuarioId.toString(),
        "username": user.username,
        "senha": user.senha,
        "status": user.status.toString(),
        "usuario_id": user.usuarioId.toString(),
        "familia_id": user.familiaId.toString()
      };

      var response = await httpClient.post(
        userUrl,
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  updateUser(
      String token, User user, File? imageFile, String? oldImagePath) async {
    try {
      var userUrl = Uri.parse('$baseUrl/v1/usuario/update/${user.id}');

      var requestBody = {
        "nome": user.nome,
        "tipousuario_id": user.tipousuarioId.toString(),
        "status": user.status.toString(),
        "usuario_id": user.usuarioId.toString(),
      };

      if (user.username!.isNotEmpty) {
        requestBody['username'] = user.username;
      }
      if (user.familiaId != null && user.familiaId > 0) {
        requestBody['familia_id'] = user.familiaId.toString();
      }

      if (user.senha!.isNotEmpty) {
        requestBody['senha'] = user.senha;
      }

      if (imageFile != null &&
          imageFile.path.isNotEmpty &&
          imageFile.path != oldImagePath) {
        var request = http.MultipartRequest('POST', userUrl);
        requestBody.removeWhere((key, value) => value == null);
        request.fields.addAll(requestBody.cast<String, String>());

        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imageFile.path,
        ));

        request.headers.addAll({
          "Content-Type": "multipart/form-data",
          'Accept': 'application/json',
          "Authorization": token,
        });

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

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
      } else {
        var response = await httpClient.post(
          userUrl,
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
      }
    } catch (err) {
      ErrorHandler.showError(err);
    }
    return null;
  }

  deleteUser(String token, User user) async {
    try {
      var userUrl = Uri.parse('$baseUrl/v1/usuario/delete/${user.id}');

      var response = await httpClient.delete(userUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        "status": user.status.toString(),
      });
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

  updateFirebaseTokenUser(String token, User user, String tokenFirebase) async {
    try {
      var userUrl =
          Uri.parse('$baseUrl/v1/usuario/update-token-firebase/${user.id}');

      var requestBody = {
        "token_firebase": tokenFirebase,
      };

      var response = await httpClient.put(
        userUrl,
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  getAllTypeUser(String token) async {
    try {
      var churchUrl = Uri.parse('$baseUrl/v1/tipousuario/list');
      var response = await httpClient.get(
        churchUrl,
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
      ErrorHandler.showError(err);
    }
    return null;
  }

  approveUser(String token, int tipoUsuarioId, int idAprovacao, int idMensagem,
      int usuarioId, int familiaId, String action) async {
    try {
      var approveUser = Uri.parse('$baseUrl/v1/usuario/aprovar-negar');

      var requestBody = {
        "idAprovacao": idAprovacao.toString(),
        "tipousuario_id": tipoUsuarioId.toString(),
        "idMensagem": idMensagem.toString(),
        "usuario_id": usuarioId.toString(),
        "action": action
      };

      if (tipoUsuarioId == 3) {
        requestBody['familia_id'] = familiaId.toString();
      }

      var response = await httpClient.post(
        approveUser,
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
      }
    } catch (err) {
      ErrorHandler.showError(err);
    }
    return null;
  }

  deleteAccount(String token, String password) async {
    final id = UserStorage.getUserId();
    var loginUrl = Uri.parse('$baseUrl/v1/usuario/remove/$id');

    try {
      var response = await httpClient.post(loginUrl, headers: {
        "Accept": "application/json",
        "Authorization": token,
      }, body: {
        'senha': password
      });

      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
