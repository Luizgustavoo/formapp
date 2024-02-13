import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();

  getAll(String token) async {
    List<Family> list = <Family>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      // print(Family.fromJson(e).toJson());
      list.add(Family.fromJson(e));
    });

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }

  insert(String token, Family family) async {
    var response = await apiClient.insert(token, family);

    return response;
  }
}
