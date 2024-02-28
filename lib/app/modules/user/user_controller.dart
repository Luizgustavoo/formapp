import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<User> listUsers = <User>[].obs;

  final box = GetStorage('credenciado');
  final repository = Get.find<UserRepository>();

  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  @override
  void onClose() {
    getUsers();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      getUsers();
    } else {
      listUsers.assignAll(listUsers
          .where((user) =>
              user.nome!.toLowerCase().contains(query.toLowerCase()) ||
              user.username!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void getUsers() async {
    final token = box.read('auth')['access_token'];

    // ignore: prefer_interpolation_to_compose_strings
    listUsers.value = await repository.getAll("Bearer " + token);
  }

  //*VALIDAÇÕES*/
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor digite sua senha';
    }

    if (value.length < 4) {
      return 'A senha deve conter 4 caracteres';
    }
    return null;
  }

  String? validateLogin(String? value) {
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
  //*FIM VALIDAÇÕES*/

  saveUser() {
    if (userFormKey.currentState!.validate()) {
      // Implemente aqui a lógica para salvar o usuário
      // Pode usar os valores dos controladores nomeController, loginController e senhaController
    }
  }
}
