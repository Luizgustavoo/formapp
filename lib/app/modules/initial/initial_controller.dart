import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class InitialController extends GetxController {
  final box = GetStorage('credenciado');

  verifyAuth() {
    Auth auth = Auth.fromJson(box.read('auth'));
    print(auth);
    if (!auth.isNull) {
      return Routes.HOME;
    } else {
      return Routes.LOGIN;
    }
  }
}
