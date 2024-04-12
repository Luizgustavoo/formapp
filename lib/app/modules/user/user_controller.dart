import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/models/user_type_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/repository/auth_repository.dart';
import 'package:ucif/app/data/repository/user_repository.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<User> listUsers = <User>[].obs;

  final box = GetStorage('credenciado');
  final repository = Get.put(UserRepository());

  User? selectedUser;
  RxInt? familyUser = 0.obs;

  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> perfilFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = true.obs;

  RxBool isPasswordVisible = false.obs;

  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  dynamic mensagem;

  final userRepository = Get.find<UserRepository>();
  // final familyController = Get.put(FamilyController());
  final authRepository = Get.put(AuthRepository());

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isLoadingMore = false;

  var isImagePicPathSet = false.obs;
  var photoUrlPath = ''.obs;
  RxString oldImagePath = ''.obs;

  RxList<TypeUser> listTypeUsers = <TypeUser>[].obs;

  // final token = UserStorage.getToken();

  @override
  void onInit() async {
    if (UserStorage.existUser()) {
      if (await ConnectionStatus.verifyConnection()) {
        getTypeUser();
        getUsers();
      } else {
        final internetStatusProvider = Get.find<InternetStatusProvider>();
        final statusStream = internetStatusProvider.statusStream;
        statusStream.listen(
          (status) {
            if (status == InternetStatus.connected) {
              getUsers();
              getTypeUser();
            }
          },
        );
      }
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoadingMore) {
          loadMoreUsers().then((value) => isLoading.value = false);
        }
      }
    });

    super.onInit();
  }

  void logout() {
    authRepository.getLogout();
  }

  Future<void> loadMoreUsers() async {
    try {
      final token = UserStorage.getToken();
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      final moreUsers =
          await repository.getAll("Bearer $token", page: nextPage);
      if (moreUsers.isNotEmpty) {
        for (final user in moreUsers) {
          if (!listUsers
              .any((existingFamily) => existingFamily.id == user.id)) {
            listUsers.add(user);
          }
        }
        currentPage = nextPage;
      } else {}
    } catch (e) {
      ErrorHandler.showError(e);
    } finally {
      isLoadingMore = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        await getUsers();
      } else {
        final filteredFamilies = listUsers
            .where((family) =>
                family.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        listUsers.assignAll(filteredFamilies);
      }
    } catch (error) {
      ErrorHandler.showError(error);
    } finally {
      if (query.isEmpty) {
        loadMoreUsers(); // Carrega mais famílias quando a pesquisa é limpa
      }
    }
  }

  Future<void> getUsers({int? page, String? search}) async {
    isLoading.value = true;
    final token = UserStorage.getToken();
    try {
      listUsers.value =
          await repository.getAll("Bearer $token", page: page, search: search);

      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }

  Future<void> getTypeUser() async {
    isLoading.value = true;
    try {
      final token = UserStorage.getToken();
      listTypeUsers.value = await repository.getAllTypeUser("Bearer $token");
      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }

  void setImagePeople(String path) {
    photoUrlPath.value = path;
    isImagePicPathSet.value = true;
  }

  Future<void> takePhoto(ImageSource source) async {
    File? pickedFile;
    ImagePicker imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: source, imageQuality: 100);

    pickedFile = File(pickedImage!.path);
    setImagePeople(pickedFile.path);
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

  Future<Map<String, dynamic>> saveUser() async {
    if (userFormKey.currentState!.validate()) {
      User user = User(
          nome: nameController.text,
          username: usernameController.text,
          senha: passwordController.text,
          tipousuarioId: 3,
          status: 1,
          usuarioId: UserStorage.getUserId(),
          familiaId: familyUser!.value);
      final token = UserStorage.getToken();
      if (await ConnectionStatus.verifyConnection()) {
        mensagem = await userRepository.insertUser("Bearer $token", user);
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

  Future<Map<String, dynamic>> updateUser(int id, int tipoUsuarioId) async {
    if (userFormKey.currentState!.validate()) {
      String imagePath = photoUrlPath.value;

      User user = User(
        id: id,
        nome: nameController.text,
        username: usernameController.text,
        senha: passwordController.text,
        tipousuarioId: tipoUsuarioId,
        status: 1,
        usuarioId: UserStorage.getUserId(),
        familiaId: familyUser?.value,
      );
      final token = UserStorage.getToken();

      final mensagem = await repository.updateUser(
        "Bearer $token",
        user,
        File(imagePath),
        oldImagePath.value,
      );

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        } else if (mensagem['message'] == 'ja_existe') {
          retorno = {
            "return": 1,
            "message": "Já existe uma família com esse nome!"
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

  Future<Map<String, dynamic>> updateFirebaseTokenUser(
      {int? id, String? tokenFirebase}) async {
    User user = User(id: id, tokenFirebase: tokenFirebase);

    final token = box.read('auth')['access_token'];

    final mensagem = await repository.updateFirebaseTokenUser(
        "Bearer $token", user, tokenFirebase!);

    if (mensagem == null) {
      if (mensagem['message'] == 'success') {
        retorno = {"return": 1, "message": "Falha ao cadastrar token!"};
      }
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
    passwordController.text = '';
    //familyController.selectedFamily = selectedUser!.family;
  }

  void fillInPerfilFields() {
    nameController.text = UserStorage.getUserName();
    usernameController.text = UserStorage.getUserLogin();
    passwordController.text = '';
    isImagePicPathSet.value = false;
    photoUrlPath.value = UserStorage.getUserPhoto();
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

  Future<Map<String, dynamic>> approveUser(int tipoUsuarioId, int idAprovacao,
      int idMensagem, int usuarioId, int familiaId, String action) async {
    if (await ConnectionStatus.verifyConnection()) {
      final token = UserStorage.getToken();
      mensagem = await userRepository.approveUser("Bearer $token",
          tipoUsuarioId, idAprovacao, idMensagem, usuarioId, familiaId, action);
      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        } else if (mensagem['message'] == 'ja_existe') {
          retorno = {
            "return": 1,
            "message": "Já existe um usuário com esse e-mail!"
          };
        }
      }
    }

    getUsers();

    return retorno;
  }
}
