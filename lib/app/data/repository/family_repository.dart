import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/utils/internet_connection_status.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();
  final DatabaseHelper localDatabase = DatabaseHelper();

  getAll(String token) async {
    List<Family> list = <Family>[];

    var responseLocal = await apiClient.getAllFamiliesLocally();

    for (var familyLocal in responseLocal) {
      Family f = Family.fromJson(familyLocal);
      f.familyLocal = true;
      list.add(f);
    }

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);
      response.forEach((e) {
        Family f = Family.fromJson(e);
        f.familyLocal = false;
        list.add(f);
      });
    }
    // for (Family family in list) {
    //   print(family.nome);
    // }
    return list;
  }

  insertFamily(String token, Family family) async {
    try {
      var response = await apiClient.insertFamily(token, family);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }

  updateFamily(String token, Family family) async {
    try {
      var response = await apiClient.updateFamily(token, family);

      return response;
    } catch (e) {
      print('Erro ao atualizar a família: $e');
      rethrow;
    }
  }

  saveFamilyLocal(Family family) async {
    try {
      var response = await apiClient.saveFamilyLocal(family);
      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }
}
