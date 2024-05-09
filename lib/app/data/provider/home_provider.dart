import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class HomeApiClient {
  final http.Client httpClient = http.Client();
  getCountGenre() async {
    try {
      var genreUrl = Uri.parse('$baseUrl/v1/pessoa/count-genero');

      var response = await httpClient.get(
        genreUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${UserStorage.getToken()}",
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (err) {
      ErrorHandler.showError("Sem conexão! Tente novamente mais tarde.");
    }
    return null;
  }

  getCountFamiliesAndPeople() async {
    try {
      var id = UserStorage.getUserId();

      var countFamiliesUrl = Uri.parse('$baseUrl/v1/familia/count/$id');

      var response = await httpClient.get(
        countFamiliesUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${UserStorage.getToken()}",
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
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

  getPeoples(String token, {int? page, String? search}) async {
    final id = UserStorage.getUserId();
    final familiaId = UserStorage.getFamilyId();
    try {
      Uri peopleUrl;
      if (UserStorage.getUserType() == 3) {
        String url = search != null
            ? '$baseUrl/v1/pessoa/list-familiar-paginate/id/$familiaId/$search/?page=1&limit'
            : '$baseUrl/v1/pessoa/list-familiar-paginate/id/$familiaId/?page=1&limit';
        peopleUrl = Uri.parse(url);
      } else {
        if (UserStorage.getUserType() == 1) {
          String url = search != null
              ? '$baseUrl/v1/pessoa/list-paginate-adm/$search/?page=$page&limit'
              : '$baseUrl/v1/pessoa/list-paginate-adm/?page=$page&limit';
          peopleUrl = Uri.parse(url);
        } else {
          String url = search != null
              ? '$baseUrl/v1/pessoa/list-paginate-credenciado/id/$id/$search/?page=$page&limit'
              : '$baseUrl/v1/pessoa/list-paginate-credenciado/id/$id/?page=$page&limit';
          peopleUrl = Uri.parse(url);
        }
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
      //
    }
    return null;
  }
}
