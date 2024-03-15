import 'package:formapp/app/modules/perfil/perfil_controller.dart';
import 'package:get/get.dart';

class PerfilBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilController>(() => PerfilController());
  }
}
