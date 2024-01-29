import 'package:formapp/app/modules/login/login_binding.dart';
import 'package:formapp/app/modules/login/login_view.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ApppPages {
  static const LOGIN = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    )
  ];
}
