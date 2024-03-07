import 'package:formapp/app/data/models/marital_status_model.dart';
import 'package:formapp/app/data/provider/marital_status_provider.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get_storage/get_storage.dart';

class MaritalStatusRepository {
  final MaritalStatusApiClient apiClient = MaritalStatusApiClient();
  final box = GetStorage();

  Future<List<MaritalStatus>> getAll(String token) async {
    List<dynamic> localData = [];
    List<MaritalStatus> localMaritalStatusList = [];

    if (box.hasData('maritalStatus')) {
      List<dynamic> localData = box.read<List<dynamic>>('maritalStatus')!;
      localMaritalStatusList = localData
          .map((e) => MaritalStatus.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<MaritalStatus> list = <MaritalStatus>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);
      if (response != null) {
        response.forEach((e) {
          list.add(MaritalStatus.fromJson(e));
        });
        box.write('maritalStatus', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localMaritalStatusList;
    }
    return list;
  }
}
