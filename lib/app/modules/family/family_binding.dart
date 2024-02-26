import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/data/repository/church_repository.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/data/repository/family_service_repository.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/data/repository/people_repository.dart';
import 'package:formapp/app/data/repository/religion_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/internet_connection_status.dart';
import 'package:get/get.dart';

class FamilyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyController>(() => FamilyController());
    Get.lazyPut<FamilyRepository>(() => FamilyRepository());
    Get.lazyPut<FamilyApiClient>(() => FamilyApiClient());

    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleRepository>(() => PeopleRepository());

    Get.lazyPut<MaritalStatusRepository>(() => MaritalStatusRepository());
    Get.lazyPut<ReligionRepository>(() => ReligionRepository());
    Get.lazyPut<ChurchRepository>(() => ChurchRepository());

    Get.lazyPut<ConectionController>(() => ConectionController());
    Get.lazyPut<FamilyServiceRepository>(() => FamilyServiceRepository());
  }
}
