import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/provider/church_provider.dart';
import 'package:formapp/app/data/provider/religion_provider.dart';

class IgrejaRepository {
  final IgrejaApiClient apiClient = IgrejaApiClient();

  getALl(String token) async {
    List<Igreja> list = <Igreja>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      // print(Family.fromJson(e).toJson());
      list.add(Igreja.fromJson(e));
    });

    //print("Usuário: ${list[0].pessoas?[0].nome}");

    return list;
  }
}
