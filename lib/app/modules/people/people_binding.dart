import 'package:formapp/app/data/provider/people_provider.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class PeopleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleController>(
      () => PeopleController(),
    );
    Get.lazyPut<PeopleApiClient>(
      () => PeopleApiClient(),
    );
  }
}
