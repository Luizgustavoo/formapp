import 'package:formapp/app/data/models/estado_civil_model.dart';
import 'package:formapp/app/data/provider/marital_status_provider.dart';

class MaritalStatusRepository {
  final MaritalStatusApiClient apiClient = MaritalStatusApiClient();

  getALl(String token) async {
    List<EstadoCivil> list = <EstadoCivil>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        list.add(EstadoCivil.fromJson(e));
      });
    }

    return list;
  }
}
