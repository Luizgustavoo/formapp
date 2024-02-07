import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class FamilyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyController>(() => FamilyController());
    Get.lazyPut<EditPeopleController>(() => EditPeopleController());
    Get.lazyPut<FamilyRepository>(
      () => FamilyRepository(),
    );
    Get.lazyPut<MaritalStatusRepository>(
      () => MaritalStatusRepository(),
    );
    Get.lazyPut<FamilyApiClient>(
      () => FamilyApiClient(),
    );
  }
}
