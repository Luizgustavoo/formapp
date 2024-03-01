import 'dart:io';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/people_provider.dart';

class PeopleRepository {
  final PeopleApiClient apiClient = PeopleApiClient();

  getALl(String token) async {
    List<People> list = <People>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      list.add(People.fromJson(e));
    });

    return list;
  }

  insertPeople(String token, People pessoa, File imageFile) async {
    try {
      var response = await apiClient.insertPeople(token, pessoa, imageFile);

      return response;
    } catch (e) {
      print('Erro ao inserir a pessoa: $e');
      rethrow;
    }
  }

  updatePeople(
      String token, People pessoa, File imageFile, String? oldImagePath) async {
    try {
      var response =
          await apiClient.updatePeople(token, pessoa, imageFile, oldImagePath);

      return response;
    } catch (e) {
      print('Erro ao editar a pessoa: $e');
      rethrow;
    }
  }

  savePeopleLocal(People people) async {
    try {
      var response = await apiClient.savePeopleLocal(people);
      return response;
    } catch (e) {
      print('Erro ao salvar a pessoa local: $e');
      rethrow;
    }
  }

  changePeopleFamily(String token, People pessoa) async {
    try {
      var response = await apiClient.changePeopleFamily(token, pessoa);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }
}
