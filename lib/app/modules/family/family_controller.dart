import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyController extends GetxController {
  final box = GetStorage('credenciado');
  List<Family>? families;

  RxList<Family> listFamilies = <Family>[].obs;

  final repository = Get.find<FamilyRepository>();

  @override
  void onInit() {
    getFamilies();
    super.onInit();
  }

  void getFamilies() async {
    final token = box.read('auth')['access_token'];

    listFamilies.value = await repository.getALl("Bearer " + token);

    print(listFamilies.value);
  }
}
