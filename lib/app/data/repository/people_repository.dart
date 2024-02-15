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
      // print(Family.fromJson(e).toJson());
      list.add(Family.fromJson(e));
    });

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }

  insertPeople(String token, Pessoas pessoa, File imageFile) async {
    try {
      var response = await apiClient.insertPeople(token, pessoa, imageFile);
      // print('Resposta da inserção: $response'); // Adicione este log
      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e'); // Adicione este log
      rethrow; // Adicione esta linha para relançar a exceção e tratá-la no controller
    }
  }
}
