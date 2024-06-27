// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/routes/app_routes.dart';

class InitialController extends GetxController {
  final box = GetStorage('credenciado');
  var auth;

  @override
  void onInit() {
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
