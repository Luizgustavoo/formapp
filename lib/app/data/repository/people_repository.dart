import 'dart:io';

import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/provider/people_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';

class PeopleRepository {
  final PeopleApiClient apiClient = PeopleApiClient();

  getAll(String token, {int? page}) async {
    List<People> list = <People>[];

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token, page: page);
      List<People> newPeoples = [];
      response['data'].forEach((e) {
        People p = People.fromJson(e);
        newPeoples.add(p);
      });
      if (page == 1) {
        list.clear();
      }
      for (var family in newPeoples) {
        if (!list.contains(family)) {
          list.add(family);
        }
      }
    }
    return list;
  }

  insertPeople(
      String token, People pessoa, File imageFile, bool peopleLocal) async {
    try {
      var response =
          await apiClient.insertPeople(token, pessoa, imageFile, peopleLocal);

      return response;
    } catch (e) {
      throw Exception('Erro ao inserir a pessoa: $e');
    }
  }

  updatePeople(String token, People pessoa, File imageFile,
      String? oldImagePath, bool peopleLocal) async {
    try {
      var response = await apiClient.updatePeople(
          token, pessoa, imageFile, oldImagePath, peopleLocal);

      return response;
    } catch (e) {
      throw Exception('Erro ao editar a pessoa: $e');
    }
  }

  savePeopleLocal(People people) async {
    try {
      var response = await apiClient.savePeopleLocal(people);
      return response;
    } catch (e) {
      throw Exception('Erro ao salvar a pessoa local: $e');
    }
  }

  changePeopleFamily(String token, People pessoa) async {
    try {
      var response = await apiClient.changePeopleFamily(token, pessoa);

      return response;
    } catch (e) {
      throw Exception('Erro ao inserir a família: $e');
    }
  }
}
