import 'package:formapp/app/data/provider/people_provider.dart';
import 'package:formapp/app/data/repository/church_repository.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/data/repository/family_service_repository.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/data/repository/people_repository.dart';
import 'package:formapp/app/data/repository/religion_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class PeopleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleApiClient>(() => PeopleApiClient());
    Get.lazyPut<PeopleRepository>(() => PeopleRepository());

    Get.lazyPut<FamilyController>(() => FamilyController());
    Get.lazyPut<FamilyRepository>(() => FamilyRepository());
    Get.lazyPut<FamilyServiceRepository>(() => FamilyServiceRepository());
    Get.lazyPut<MaritalStatusRepository>(() => MaritalStatusRepository());
    Get.lazyPut<ReligionRepository>(() => ReligionRepository());
    Get.lazyPut<ChurchRepository>(() => ChurchRepository());
  }
}
