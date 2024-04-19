import 'package:get/get.dart';
import 'package:ucif/app/data/provider/people_provider.dart';
import 'package:ucif/app/data/repository/people_repository.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

class PeopleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleApiClient>(() => PeopleApiClient());
    Get.lazyPut<PeopleRepository>(() => PeopleRepository());
    // Get.lazyPut<FamilyServiceRepository>(() => FamilyServiceRepository());
    // Get.lazyPut(() => FamilyController());
  }
}
