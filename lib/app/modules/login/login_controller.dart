import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/auth_model.dart';
import 'package:ucif/app/data/repository/auth_repository.dart';
import 'package:ucif/app/data/repository/church_repository.dart';
import 'package:ucif/app/data/repository/marital_status_repository.dart';
import 'package:ucif/app/data/repository/religion_repository.dart';
import 'package:ucif/app/global/storage_manager.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  RxInt onToggle = 0.obs;
  RxBool loading = false.obs;

  final repository = Get.put(AuthRepository());
  Auth? auth;
  final formKey = GlobalKey<FormState>();

  final forgotKey = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController forgotPasswordCtrl = TextEditingController();

  //Controller e keys do cadastro do usuario
  final signupKey = GlobalKey<FormState>();
  TextEditingController nameSignUpCtrl = TextEditingController();
  TextEditingController usernameSignUpCtrl = TextEditingController();
  TextEditingController passwordSignUpCtrl = TextEditingController();
  TextEditingController confirmPasswordSignUpCtrl = TextEditingController();

  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  final box = GetStorage('credenciado');

  RxBool isLoggingIn = false.obs;
  RxString errorMessage = ''.obs;
  RxBool showErrorSnackbar = false.obs;
  dynamic mensagem;

  final userController = Get.put(UserController());

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoggingIn.value = true;
      loading.value = true;

      auth = await repository.getLogin(usernameCtrl.text, passwordCtrl.text);

      if (auth != null) {
        box.write('auth', auth?.toJson());

        StorageManager.addUser(auth!.user!.id!);

        final String? token = await FirebaseMessaging.instance.getToken();
        final id = box.read('auth')['user']['id'];
        userController.updateFirebaseTokenUser(id: id, tokenFirebase: token);

        final MaritalStatusRepository repositoryMarital =
            Get.find<MaritalStatusRepository>();
        final ReligionRepository repositoryReligion =
            Get.put(ReligionRepository());
        final ChurchRepository churchReligion = Get.put(ChurchRepository());

        await repositoryMarital.getAll("Bearer ${UserStorage.getToken()}");
        await repositoryReligion.getAll("Bearer ${UserStorage.getToken()}");
        await churchReligion.getAll("Bearer ${UserStorage.getToken()}");

        Get.offAllNamed('/home');
      } else {
        showErrorSnackbar.value = true;
        showErrorMessage();
      }

      loading.value = false;
      isLoggingIn.value = false;
    }
  }

  Future<Map<String, dynamic>> signUp() async {
    if (signupKey.currentState!.validate()) {
      if (passwordSignUpCtrl.text == confirmPasswordSignUpCtrl.text) {
        isLoggingIn.value = true;
        loading.value = true;

        mensagem = await repository.getSignUp(nameSignUpCtrl.text,
            usernameSignUpCtrl.text, passwordSignUpCtrl.text);

        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            retorno = {
              "return": 0,
              "message":
                  "Sucesso! Fique atento ao seu e-mail cadastrado, pois iremos informar o status da sua solicitação."
            };
          } else if (mensagem['message'] == 'ja_existe') {
            retorno = {
              "return": 1,
              "message": "Já existe um usuário com esse nome!"
            };
          } else {
            retorno = {"return": 1, "message": "Falha!"};
          }
        } else {
          showErrorSnackbar.value = true;
          showErrorMessage();
        }

        loading.value = false;
        isLoggingIn.value = false;
      }
    }
    return retorno;
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

  String? validatePassword(String? value, bool isLogin) {
    if (value == null || value.isEmpty) {
      return 'Por favor digite sua senha';
    }

    if (!isLogin) {
      if (value != passwordSignUpCtrl.text) {
        return 'A senhas não coincidem';
      }
    }

    if (value.length < 4) {
      return 'A senha deve conter 4 caracteres';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu nome completo';
    }
    List<String> partesNome = value.split(' ');
    if (partesNome.length < 2) {
      return 'Por favor, digite pelo menos um nome e um sobrenome';
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

  Future<Map<String, dynamic>> forgotPassword(String username) async {
    try {
      if (forgotKey.currentState!.validate()) {
        mensagem = await repository.forgotPassword(username);

        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            retorno = {
              "return": 0,
              "message": "Senha temporária enviada por e-mail!"
            };
          } else {
            retorno = {"return": 1, "message": "Falha!"};
          }
        }
      }
    } catch (e) {
      ErrorHandler.showError(e);
    }
    return retorno;
  }

  void clearAllSignUpTextFields() {
    final textControllers = [
      nameSignUpCtrl,
      usernameSignUpCtrl,
      passwordSignUpCtrl,
      confirmPasswordSignUpCtrl
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
