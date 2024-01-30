import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/data/repository/auth_repository.dart';
import 'package:formapp/app/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  RxInt onToggle = 0.obs;
  RxBool loading = false.obs;

  final repository = Get.find<AuthRepository>();
  Auth? auth;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final box = GetStorage('credenciado');

  void login() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;

      try {
        auth = await repository.getLogin(usernameCtrl.text, passwordCtrl.text);

        //if (auth != null ) {
        if (2 > 0) {
          box.write('auth', auth);
          // print(auth!.toJson());
          print(box.read('auth'));
          Get.to(const HomePage());
        } else {
          Get.toNamed('/login');
        }
        loading.value = false;
      } catch (e) {
        print(e);
        loading.value = false;
      }
    }
  }
}