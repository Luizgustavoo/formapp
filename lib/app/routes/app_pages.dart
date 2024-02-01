import 'package:formapp/app/modules/home/home_binding.dart';
import 'package:formapp/app/modules/home/home_view.dart';
import 'package:formapp/app/modules/initial/initial_binding.dart';
import 'package:formapp/app/modules/initial/initial_view.dart';
import 'package:formapp/app/modules/login/login_binding.dart';
import 'package:formapp/app/modules/login/login_view.dart';
import 'package:formapp/app/modules/user/user_binding.dart';
import 'package:formapp/app/modules/user/user_view.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ApppPages {
  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.USER,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
  ];
}
