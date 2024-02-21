import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();

  getAll(String token) async {
    List<Family> list = <Family>[];

    var response = await apiClient.getAll(token);
    var responseLocal = await apiClient.getAllFamiliesLocally();

    for (var e in responseLocal) {
      print(Family.fromJson(e).toJson());
      list.add(Family.fromJson(e));
    }

    response.forEach((e) {
      // print(Family.fromJson(e).toJson());
      list.add(Family.fromJson(e));
    });

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }

  insertFamily(String token, Family family) async {
    try {
      var response = await apiClient.insertFamily(token, family);
      // print('Resposta da inserção: $response'); // Adicione este log
      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e'); // Adicione este log
      rethrow; // Adicione esta linha para relançar a exceção e tratá-la no controller
    }
  }

  updateFamily(String token, Family family) async {
    try {
      var response = await apiClient.updateFamily(token, family);
      // print('Resposta da inserção: $response'); // Adicione este log
      return response;
    } catch (e) {
      print('Erro ao atualizar a família: $e'); // Adicione este log
      rethrow; // Adicione esta linha para relançar a exceção e tratá-la no controller
    }
  }

  saveFamilyLocal(Family family) async {
    try {
      var response = await apiClient.saveFamilyLocal(family);
      // print('Resposta da inserção: $response'); // Adicione este log
      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e'); // Adicione este log
      rethrow; // Adicione esta linha para relançar a exceção e tratá-la no controller
    }
  }
}
