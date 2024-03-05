// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var box;
  RxString username = "".obs;

  @override
  void onInit() {
    box = GetStorage('credenciado');
    username.value = box.read('auth')['user']['nome'] ?? "Sem dados";
    super.onInit();
  }

  void exit() {
    box.erase();
    Get.offAllNamed('/login');
  }
}
