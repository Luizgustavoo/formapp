import 'package:get/get.dart';
import 'package:ucif/app/data/provider/auth_provider.dart';
import 'package:ucif/app/data/repository/auth_repository.dart';
import 'package:ucif/app/modules/login/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AuthApiClient>(() => AuthApiClient());
  }
}
