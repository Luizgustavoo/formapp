import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/provider/church_provider.dart';
import 'package:get_storage/get_storage.dart';

class ChurchRepository {
  final ChurchApiClient apiClient = ChurchApiClient();
  final box = GetStorage();

  Future<List<Igreja>> getAll(String token) async {
    // Verifica se existem dados salvos localmente
    if (box.hasData('church')) {
      List<dynamic> localData = box.read<List<dynamic>>('church')!;
      List<Igreja> localChurchList = localData
          .map((e) => Igreja.fromJson(e as Map<String, dynamic>))
          .toList();
      return localChurchList;
    } else {
      // Se não houver dados salvos localmente, solicite à API
      List<Igreja> list = <Igreja>[];

      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Igreja.fromJson(e));
        });

        // Salva os dados localmente
        box.write('church', list.map((e) => e.toJson()).toList());
      }

      return list;
    }
  }
}
