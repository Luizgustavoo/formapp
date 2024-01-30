import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = GetStorage('credenciado');
  RxString username = ''.obs;

  @override
  void onInit() {
    // Obtém o nome do usuário ao inicializar o controlador
    super.onInit();
    username.value = box.read('user')?['nome'] ?? '';
  }

  void clear() {
    box.erase();
    Get.offAllNamed('/login');
  }
}
