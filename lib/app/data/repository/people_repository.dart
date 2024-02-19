import 'dart:io';

import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/people_provider.dart';

class PeopleRepository {
  final PeopleApiClient apiClient = PeopleApiClient();

  getALl(String token) async {
    List<Family> list = <Family>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      list.add(Family.fromJson(e));
    });

    return list;
  }

  insertPeople(String token, People pessoa, File imageFile) async {
    try {
      var response = await apiClient.insertPeople(token, pessoa, imageFile);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }

  updatePeople(String token, People pessoa, File imageFile) async {
    try {
      var response = await apiClient.updatePeople(token, pessoa, imageFile);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }
}
