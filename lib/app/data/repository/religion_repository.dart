import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/provider/religion_provider.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get_storage/get_storage.dart';

class ReligionRepository {
  final ReligionApiClient apiClient = ReligionApiClient();
  final box = GetStorage();

  Future<List<Religion>> getAll(String token) async {
    List<dynamic> localData = [];
    List<Religion> localReligionList = [];

    if (box.hasData('religion')) {
      localData = box.read<List<dynamic>>('religion')!;
      localReligionList = localData
          .map((e) => Religion.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Religion> list = <Religion>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Religion.fromJson(e));
        });

        box.write('religion', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localReligionList;
    }

    return list;
  }
}
