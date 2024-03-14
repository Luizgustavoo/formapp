// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:formapp/app/data/repository/auth_repository.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var box;
  RxString username = "".obs;
  final repository = Get.find<AuthRepository>();

  @override
  void onInit() async {
    username.value = UserStorage.getUserName() ?? "Sem dados";

    super.onInit();
  }

  void logout() {
    // repository.getLogout();

    final box = GetStorage('credenciado');
    box.erase();

    Get.offAllNamed('/login');
  }
}
