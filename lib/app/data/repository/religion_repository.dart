import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/provider/religion_provider.dart';

class ReligionRepository {
  final ReligionApiClient apiClient = ReligionApiClient();

  getALl(String token) async {
    List<Religiao> list = <Religiao>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        // print(Family.fromJson(e).toJson());
        list.add(Religiao.fromJson(e));
      });
    }

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }
}
