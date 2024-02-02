import 'package:formapp/app/data/models/family_model.dart';
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
}
