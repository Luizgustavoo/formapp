import 'package:formapp/app/data/provider/people_provider.dart';
import 'package:formapp/app/data/repository/family_service_repository.dart';
import 'package:formapp/app/data/repository/people_repository.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class PeopleBinding implements Bindings {
  @override
  void dependencies() {
    print('DAQUI PRA BAIXO');
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleApiClient>(() => PeopleApiClient());
    Get.lazyPut<PeopleRepository>(() => PeopleRepository());
    Get.lazyPut<FamilyServiceRepository>(() => FamilyServiceRepository());
  }
}
