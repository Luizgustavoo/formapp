import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = GetStorage('credenciado');
  RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();

    var authData = box.read('auth') ?? {};

    username.value = authData['user']['nome'] ?? '';
  }

  void clear() {
    box.erase();
    Get.offAllNamed('/login');
  }
}
