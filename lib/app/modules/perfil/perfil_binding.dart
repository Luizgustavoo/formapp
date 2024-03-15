import 'package:formapp/app/data/repository/people_repository.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/modules/perfil/perfil_controller.dart';
import 'package:get/get.dart';

class PerfilBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilController>(() => PerfilController());
    Get.lazyPut<PeopleController>(() => PeopleController());
    Get.lazyPut<PeopleRepository>(() => PeopleRepository());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
