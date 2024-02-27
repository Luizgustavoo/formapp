import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/data/repository/auth_repository.dart';
import 'package:formapp/app/global/widgets/login_modal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  RxInt onToggle = 0.obs;
  RxBool loading = false.obs;

  final repository = Get.put(AuthRepository());
  Auth? auth;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final box = GetStorage('credenciado');

  RxString errorMessage = ''.obs;

  RxBool showErrorSnackbar = false.obs;
  void login() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;

      auth = await repository.getLogin(usernameCtrl.text, passwordCtrl.text);

      if (auth != null) {
        final atualHour = DateTime.now();
        box.write('auth', auth?.toJson());
        box.write('dataLogin', atualHour);
        Get.offAllNamed('/home');
      } else {
        showErrorSnackbar.value = true;
        showErrorMessage();
      }

      loading.value = false;
    }
  }

  //*VALIDAÇÕES */
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor digite seu usuário';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor digite sua senha';
    }

    if (value.length < 4) {
      return 'A senha deve conter 4 caracteres';
    }
    return null;
  }

  void showErrorMessage() {
    if (showErrorSnackbar.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Erro de Autenticação',
          'Usuário ou senha inválidos',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        showErrorSnackbar.value = false;
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  //*TOKEN EXPIROU*/
  void verificarTokenExpirado() {
    if (tokenExpirou()) {
      exibirModalLogin();
    }
  }

  bool tokenExpirou() {
    final authData = box.read('auth');
    if (authData != null) {
      final expiresIn = authData['expires_in'] as String?;
      if (expiresIn != null) {
        final expirationDate = DateTime.parse(expiresIn);
        return DateTime.now().isAfter(expirationDate);
      }
    }
    return true;
  }

  void exibirModalLogin() {
    Get.dialog(LoginModal());
  }
}
