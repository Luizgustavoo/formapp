import 'package:formapp/app/data/repository/auth_repository.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
