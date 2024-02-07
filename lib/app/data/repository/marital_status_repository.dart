import 'package:formapp/app/data/models/estado_civil_model.dart';
import 'package:formapp/app/data/provider/marital_status_provider.dart';

class MaritalStatusRepository {
  final MaritalStatusApiClient apiClient = MaritalStatusApiClient();

  getALl(String token) async {
    List<EstadoCivil> list = <EstadoCivil>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      // print(Family.fromJson(e).toJson());
      list.add(EstadoCivil.fromJson(e));
    });

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }
}
