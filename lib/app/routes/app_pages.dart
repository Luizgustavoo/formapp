import 'package:formapp/app/modules/family/family_binding.dart';
import 'package:formapp/app/modules/family/views/create_family_view.dart';
import 'package:formapp/app/modules/family/views/edit_family_view.dart';
import 'package:formapp/app/modules/family/views/list_family_view.dart';
import 'package:formapp/app/modules/home/home_binding.dart';
import 'package:formapp/app/modules/home/home_view.dart';
import 'package:formapp/app/modules/initial/initial_binding.dart';
import 'package:formapp/app/modules/initial/initial_view.dart';
import 'package:formapp/app/modules/login/login_binding.dart';
import 'package:formapp/app/modules/login/login_view.dart';
import 'package:formapp/app/modules/people/people_binding.dart';
import 'package:formapp/app/modules/people/views/edit_people_view.dart';
import 'package:formapp/app/modules/user/user_binding.dart';
import 'package:formapp/app/modules/user/views/create_user_view.dart';
import 'package:formapp/app/modules/user/views/list_user_view.dart';
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
      name: Routes.LIST_FAMILY,
      page: () => const FamilyView(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: Routes.EDIT_FAMILY,
      page: () => const EditFamilyView(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: Routes.CREATE_FAMILY,
      page: () => const CreateFamilyView(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PEOPLE,
      page: () => EditPeopleView(),
      binding: PeopleBinding(),
    ),
    GetPage(
      name: Routes.LIST_USER,
      page: () => const ListUserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.CREATE_USER,
      page: () => const CreateUserView(),
      binding: UserBinding(),
    ),
  ];
}
