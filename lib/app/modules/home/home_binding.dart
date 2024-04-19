import 'package:get/get.dart';
import 'package:ucif/app/data/repository/auth_repository.dart';
import 'package:ucif/app/data/repository/home_repository.dart';
import 'package:ucif/app/modules/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<HomeRepository>(() => HomeRepository());
  }
}
