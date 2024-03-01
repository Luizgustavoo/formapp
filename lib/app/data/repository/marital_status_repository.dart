import 'package:formapp/app/data/models/marital_status_model.dart';
import 'package:formapp/app/data/provider/marital_status_provider.dart';
import 'package:get_storage/get_storage.dart';

class MaritalStatusRepository {
  final MaritalStatusApiClient apiClient = MaritalStatusApiClient();
  final box = GetStorage();

  Future<List<MaritalStatus>> getAll(String token) async {
    if (box.hasData('maritalStatus')) {
      List<dynamic> localData = box.read<List<dynamic>>('maritalStatus')!;
      List<MaritalStatus> localMaritalStatusList = localData
          .map((e) => MaritalStatus.fromJson(e as Map<String, dynamic>))
          .toList();
      return localMaritalStatusList;
    } else {
      List<MaritalStatus> list = <MaritalStatus>[];
      var response = await apiClient.getAll(token);
      if (response != null) {
        response.forEach((e) {
          list.add(MaritalStatus.fromJson(e));
        });
        box.write('maritalStatus', list.map((e) => e.toJson()).toList());
      }

      return list;
    }
  }
}
