import 'package:flutter/material.dart';
import 'package:formapp/app/modules/family/family_binding.dart';
import 'package:formapp/app/modules/family/views/list_family_view.dart';
import 'package:formapp/app/modules/home/home_binding.dart';
import 'package:formapp/app/modules/home/home_view.dart';
import 'package:formapp/app/modules/initial/initial_binding.dart';
import 'package:formapp/app/modules/initial/initial_view.dart';
import 'package:formapp/app/modules/login/login_binding.dart';
import 'package:formapp/app/modules/login/login_view.dart';
import 'package:formapp/app/modules/message/message_binding.dart';
import 'package:formapp/app/modules/message/views/list_message_view.dart';
import 'package:formapp/app/modules/people/people_binding.dart';
import 'package:formapp/app/modules/people/views/list_people_view.dart';
import 'package:formapp/app/modules/perfil/perfil_binding.dart';
import 'package:formapp/app/modules/perfil/perfil_view.dart';
import 'package:formapp/app/modules/user/user_binding.dart';
import 'package:formapp/app/modules/user/views/list_user_view.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static late BuildContext context;
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
      page: () => FamilyView(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: Routes.LIST_USER,
      page: () => ListUserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.LIST_PEOPLE,
      page: () => const ListPeopleView(),
      binding: PeopleBinding(),
    ),
    GetPage(
      name: Routes.LIST_MESSAGE,
      page: () => const MessageView(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.PERFIL,
      page: () => PerfilView(),
      binding: PerfilBinding(),
    ),
  ];
}
