import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/provider/church_provider.dart';

class ChurchRepository {
  final ChurchApiClient apiClient = ChurchApiClient();

  getALl(String token) async {
    List<Igreja> list = <Igreja>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      list.add(Igreja.fromJson(e));
    });

    return list;
  }
}
