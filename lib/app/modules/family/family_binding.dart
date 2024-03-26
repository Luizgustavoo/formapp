import 'package:get/get.dart';
import 'package:ucif/app/data/provider/family_provider.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/repository/family_repository.dart';
import 'package:ucif/app/data/repository/family_service_repository.dart';
import 'package:ucif/app/modules/family/family_controller.dart';

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
