import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:get/get.dart';

class FamilyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyController>(() => FamilyController());
    Get.lazyPut<FamilyRepository>(
      () => FamilyRepository(),
    );
    Get.lazyPut<FamilyApiClient>(
      () => FamilyApiClient(),
    );
  }
}
