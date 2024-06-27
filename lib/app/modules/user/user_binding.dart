import 'package:get/get.dart';
import 'package:ucif/app/data/repository/user_repository.dart';
import 'package:ucif/app/modules/user/user_controller.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());

    Get.lazyPut<UserRepository>(() => UserRepository());
  }
}
