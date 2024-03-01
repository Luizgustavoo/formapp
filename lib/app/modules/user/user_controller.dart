import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/repository/user_repository.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<User> listUsers = <User>[].obs;

  final box = GetStorage('credenciado');
  final repository = Get.find<UserRepository>();

  User? selectedUser;

  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  dynamic mensagem;

  final userRepository = Get.find<UserRepository>();

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

    listUsers.value = await repository.getAll("Bearer $token");
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

  Future<Map<String, dynamic>> saveUser() async {
    if (userFormKey.currentState!.validate()) {
      User user = User(
        nome: nameController.text,
        username: usernameController.text,
        password: passwordController.text,
        tipousuarioId: 3,
        status: 1,
        usuarioId: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      if (await ConnectionStatus.verifyConnection()) {
        mensagem = await userRepository.insertUser("Bearer $token", user);
        print(mensagem);
        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            retorno = {
              "return": 0,
              "message": "Operação realizada com sucesso!"
            };
          } else if (mensagem['message'] == 'ja_existe') {
            retorno = {
              "return": 1,
              "message": "Já existe um usuário com esse e-mail!"
            };
          }
        }
      }

      getUsers();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos do usuário!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateUser(int id) async {
    if (userFormKey.currentState!.validate()) {
      User user = User(
        id: id,
        nome: nameController.text,
        username: usernameController.text,
        password: passwordController.text,
        tipousuarioId: 3,
        status: 1,
        usuarioId: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      final mensagem = await repository.updateUser("Bearer $token", user);

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        } else if (mensagem['message'] == 'ja_existe') {
          retorno = {
            "return": 1,
            "message": "Já existe uam família com esse nome!"
          };
        }
      }

      getUsers();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteUser(int id, int status) async {
    User user = User(
      id: id,
      status: status,
    );

    final token = box.read('auth')['access_token'];

    final mensagem = await repository.deleteUser("Bearer $token", user);

    if (mensagem != null) {
      if (mensagem['message'] == 'success') {
        retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
      }
      getUsers();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  void fillInUserFields() {
    nameController.text = selectedUser!.nome.toString();
    usernameController.text = selectedUser!.username.toString();
    passwordController.text = selectedUser!.password.toString();
  }

  void clearAllUserTextFields() {
    final textControllers = [
      nameController,
      usernameController,
      passwordController
    ];
    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
