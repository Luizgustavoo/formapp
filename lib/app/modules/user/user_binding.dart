import 'package:formapp/app/data/repository/user_repository.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:get/get.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());

    Get.lazyPut<UserRepository>(() => UserRepository());
  }
}
