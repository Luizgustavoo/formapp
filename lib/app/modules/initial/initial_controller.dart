import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class InitialController extends GetxController {
  final box = GetStorage('credenciado');
  var auth;

  String verifyAuth() {
    final auth = box.read('auth');
    if (auth != null) {
      return Routes.HOME;
    }
    return Routes.LOGIN;
  }
}
