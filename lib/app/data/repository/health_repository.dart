import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/health_model.dart';
import 'package:ucif/app/data/provider/heath_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';

class HealthRepository {
  final HealthApiClient apiClient = HealthApiClient();
  final box = GetStorage();

  Future<List<Health>> getAll(String token) async {
    List<dynamic> localData = [];
    List<Health> localHealthList = [];

    if (box.hasData('health')) {
      localData = box.read<List<dynamic>>('health')!;
      localHealthList = localData
          .map((e) => Health.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Health> list = <Health>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Health.fromJson(e));
        });

        box.write('health', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localHealthList;
    }

    return list;
  }
}
