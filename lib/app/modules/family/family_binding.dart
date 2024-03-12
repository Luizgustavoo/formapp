import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/data/provider/internet_status_provider.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/data/repository/family_service_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:get/get.dart';

class FamilyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FamilyController>(FamilyController());
    Get.put<FamilyRepository>(FamilyRepository());
    Get.put<FamilyServiceRepository>(FamilyServiceRepository());
    Get.put<FamilyApiClient>(FamilyApiClient());
    Get.put<InternetStatusProvider>(InternetStatusProvider());
  }
}
