// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class InitialController extends GetxController {
  final box = GetStorage('credenciado');
  var auth;

  @override
  void onInit() {
    print('initial controller');
    auth = box.read('auth');
    super.onInit();
  }

  String verifyAuth() {
    if (auth != null) {
      return Routes.HOME;
    }
    return Routes.LOGIN;
  }
}
