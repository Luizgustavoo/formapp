import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/modules/family/family_edit_controller.dart';
import 'package:get/get.dart';

class FamilyEditBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyEditController>(() => FamilyEditController());
    Get.lazyPut<FamilyRepository>(
      () => FamilyRepository(),
    );
    Get.lazyPut<FamilyApiClient>(
      () => FamilyApiClient(),
    );
  }
}
