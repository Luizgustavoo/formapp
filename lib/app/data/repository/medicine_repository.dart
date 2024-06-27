import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/medicine_model.dart';
import 'package:ucif/app/data/provider/medicine_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';

class MedicineRepository {
  final MedicineApiClient apiClient = MedicineApiClient();
  final box = GetStorage();

  Future<List<Medicine>> getAll(String token) async {
    List<dynamic> localData = [];
    List<Medicine> localMedicineList = [];

    if (box.hasData('medicine')) {
      localData = box.read<List<dynamic>>('medicine')!;
      localMedicineList = localData
          .map((e) => Medicine.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Medicine> list = <Medicine>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);

      if (response != null) {
        response.forEach((e) {
          list.add(Medicine.fromJson(e));
        });

        box.write('medicine', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localMedicineList;
    }

    return list;
  }
}
