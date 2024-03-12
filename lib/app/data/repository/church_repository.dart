import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/provider/church_provider.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get_storage/get_storage.dart';

class ChurchRepository {
  final ChurchApiClient apiClient = ChurchApiClient();
  final box = GetStorage();

  Future<List<Church>> getAll(String token) async {
    List<dynamic> localData = [];
    List<Church> localChurchList = [];

    if (box.hasData('church')) {
      localData = box.read<List<dynamic>>('church')!;
      localChurchList = localData
          .map((e) => Church.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Church> list = <Church>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Church.fromJson(e));
        });

        box.write('church', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localChurchList;
    }

    return list;
  }
}
