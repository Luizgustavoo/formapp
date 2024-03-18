import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MaritalStatusApiClient {
  final http.Client httpClient = http.Client();

  getAll(String token) async {
    try {
      var maritalUrl = Uri.parse('$baseUrl/v1/estadocivil/list');
      var response = await httpClient.get(
        maritalUrl,
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
      print("$err");
    }
    return null;
  }
}
