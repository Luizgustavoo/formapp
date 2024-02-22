import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/utils/internet_connection_status.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();

  getAll(String token) async {
    List<Family> list = <Family>[];

    var responseLocal = await apiClient.getAllFamiliesLocally();

    for (var familyLocal in responseLocal) {
      Family f = Family.fromJson(familyLocal);
      f.familyLocal = true;
      list.add(f);
      print(f.familyLocal);
    }

    if (await ConnectionStatus.verificarConexao()) {
      var response = await apiClient.getAll(token);
      response.forEach((e) {
        // print(Family.fromJson(e).toJson());
        Family f = Family.fromJson(e);
        f.familyLocal = false;
        list.add(Family.fromJson(e));
      });
    }

    for (Family family in list) {
      print(family.nome);
    }

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
