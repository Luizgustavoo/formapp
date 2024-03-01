import 'package:formapp/app/data/models/marital_status_model.dart';
import 'package:formapp/app/data/provider/marital_status_provider.dart';

class MaritalStatusRepository {
  final MaritalStatusApiClient apiClient = MaritalStatusApiClient();

  getAll(String token) async {
    List<MaritalStatus> list = <MaritalStatus>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        list.add(MaritalStatus.fromJson(e));
      });
    }

    return list;
  }
}
