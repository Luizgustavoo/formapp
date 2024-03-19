import 'dart:io';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/people_provider.dart';

class PeopleRepository {
  final PeopleApiClient apiClient = PeopleApiClient();

  getAll(String token) async {
    List<People> list = <People>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        list.add(People.fromJson(e));
      });
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
