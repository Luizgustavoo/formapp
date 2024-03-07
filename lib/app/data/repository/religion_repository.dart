import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/provider/religion_provider.dart';
import 'package:get_storage/get_storage.dart';

class ReligionRepository {
  final ReligionApiClient apiClient = ReligionApiClient();
  final box = GetStorage();

  Future<List<Religion>> getAll(String token) async {
    if (box.hasData('religion')) {
      List<dynamic> localData = box.read<List<dynamic>>('religion')!;
      List<Religion> localReligionList = localData
          .map((e) => Religion.fromJson(e as Map<String, dynamic>))
          .toList();
      return localReligionList;
    } else {
      List<Religion> list = <Religion>[];

      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Religion.fromJson(e));
        });

        box.write('religion', list.map((e) => e.toJson()).toList());
      }

      return list;
    }
  }
}
