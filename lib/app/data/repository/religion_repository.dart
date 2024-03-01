import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/provider/religion_provider.dart';
import 'package:get_storage/get_storage.dart';

class ReligionRepository {
  final ReligionApiClient apiClient = ReligionApiClient();
  final box = GetStorage();

  Future<List<Religiao>> getAll(String token) async {
    // Verifica se existem dados salvos localmente
    if (box.hasData('religion')) {
      List<dynamic> localData = box.read<List<dynamic>>('religion')!;
      List<Religiao> localReligionList = localData
          .map((e) => Religiao.fromJson(e as Map<String, dynamic>))
          .toList();
      return localReligionList;
    } else {
      // Se não houver dados salvos localmente, solicite à API
      List<Religiao> list = <Religiao>[];

      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Religiao.fromJson(e));
        });

        // Salva os dados localmente
        box.write('religion', list.map((e) => e.toJson()).toList());
      }

      return list;
    }
  }
}
