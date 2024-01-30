import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilyApiClient {
  final http.Client httpClient = http.Client();

  // getAll(String token) async {
  //   var familyUrl = Uri.parse('$baseUrl/v1/familia/list');

  //   var response = await httpClient.get(
  //     familyUrl,
  //     headers: {
  //       "Accept": "application/json",
  //       "Authorization": token,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     List<Family> listFamily = jsonResponse['data'].map<Family>((map) {
  //       return Family.fromJson(map);
  //     }).toList();

  //     return listFamily;
  //   } else {
  //     print('erro -get:${response.body}');
  //   }

  //   print('Cheguei no final');
  //   return null;
  // }

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
}
