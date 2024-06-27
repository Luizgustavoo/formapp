import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/auth_model.dart';
import 'package:ucif/app/data/models/church_model.dart';
import 'package:ucif/app/data/models/health_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/medicine_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/repository/auth_repository.dart';
import 'package:ucif/app/data/repository/church_repository.dart';
import 'package:ucif/app/data/repository/health_repository.dart';
import 'package:ucif/app/data/repository/marital_status_repository.dart';
import 'package:ucif/app/data/repository/medicine_repository.dart';
import 'package:ucif/app/data/repository/religion_repository.dart';
import 'package:ucif/app/global/storage_manager.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/format_validator.dart';
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

  /*DADOS PARA REGISTRAR UMA PESSOA */

  TextEditingController idPessoaController = TextEditingController();
  TextEditingController nomePessoaController = TextEditingController();
  TextEditingController nascimentoPessoaController = TextEditingController();
  TextEditingController cpfPessoaController = TextEditingController();
  TextEditingController tituloEleitoralPessoaController =
      TextEditingController();
  TextEditingController zonaEleitoralPessoaController = TextEditingController();
  TextEditingController celularPessoaController = TextEditingController();
  TextEditingController redeSocialPessoaController = TextEditingController();
  TextEditingController localTrabalhoPessoaController = TextEditingController();
  TextEditingController cargoPessoaController = TextEditingController();
  TextEditingController funcaoIgrejaPessoaController = TextEditingController();
  TextEditingController statusPessoaController = TextEditingController();
  TextEditingController usuarioId = TextEditingController();
  TextEditingController familiaId = TextEditingController();
  TextEditingController igrejaPessoaController = TextEditingController();

  RxString sexo = 'Masculino'.obs;
  RxInt estadoCivilSelected = 1.obs;
  RxInt leaderSelected = 73.obs;
  RxInt religiaoSelected = 1.obs;
  RxString parentesco = 'Pai'.obs;
  RxString igreja = ''.obs;
  List<String> suggestions = [];

  RxList<MaritalStatus> listMaritalStatus = <MaritalStatus>[].obs;
  RxList<User> listLeader = <User>[].obs;
  RxList<Religion> listReligion = <Religion>[].obs;
  RxList<Church> listChurch = <Church>[].obs;
  RxList<Health> listHealth = <Health>[].obs;
  RxList<Medicine> listMedicine = <Medicine>[].obs;

/*FINAL REGISTRO PESSOA */
  final box = GetStorage('credenciado');

  RxBool isLoggingIn = false.obs;
  RxString errorMessage = ''.obs;
  RxBool showErrorSnackbar = false.obs;

  List<int?> selectedSaudeIds = <int>[].obs;
  List<int?> selectedMedicamentoIds = <int>[].obs;
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
        final ChurchRepository church = Get.put(ChurchRepository());
        final HealthRepository health = Get.put(HealthRepository());
        final MedicineRepository medicine = Get.put(MedicineRepository());

        await repositoryMarital.getAll("Bearer ${UserStorage.getToken()}");
        await repositoryReligion.getAll("Bearer ${UserStorage.getToken()}");
        await church.getAll("Bearer ${UserStorage.getToken()}");
        await health.getAll("Bearer ${UserStorage.getToken()}");
        await medicine.getAll("Bearer ${UserStorage.getToken()}");

        Get.offAllNamed('/home');
      } else {
        showErrorSnackbar.value = true;
        showErrorMessage();
      }

      loading.value = false;
      isLoggingIn.value = false;
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

  void onNascimentoChanged(String nascimento) {
    final formattedNASCIMENTO = FormattersValidators.formatDate(nascimento);
    nascimentoPessoaController.value = TextEditingValue(
      text: formattedNASCIMENTO.value,
      selection:
          TextSelection.collapsed(offset: formattedNASCIMENTO.value.length),
    );
  }

  void onCPFChanged(String cpf) {
    final formattedCPF = FormattersValidators.formatCPF(cpf);
    cpfPessoaController.value = TextEditingValue(
      text: formattedCPF.value,
      selection: TextSelection.collapsed(offset: formattedCPF.value.length),
    );
  }

  void onPhoneChanged(String phone) {
    final formattedPhone = FormattersValidators.formatPhone(phone);
    celularPessoaController.value = TextEditingValue(
      text: formattedPhone.value,
      selection: TextSelection.collapsed(offset: formattedPhone.value.length),
    );
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
      confirmPasswordSignUpCtrl,
      nomePessoaController,
      nascimentoPessoaController,
      cpfPessoaController,
      tituloEleitoralPessoaController,
      zonaEleitoralPessoaController,
      celularPessoaController,
      redeSocialPessoaController,
      localTrabalhoPessoaController,
      cargoPessoaController,
      funcaoIgrejaPessoaController,
      statusPessoaController,
      usuarioId,
      familiaId,
      igrejaPessoaController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> signUp() async {
    if (signupKey.currentState!.validate()) {
      People pessoa = People(
          nome: nomePessoaController.text,
          sexo: sexo.value,
          estadoCivilId: estadoCivilSelected.value,
          dataNascimento: nascimentoPessoaController.text,
          cpf: cpfPessoaController.text,
          telefone: celularPessoaController.text,
          redeSocial: redeSocialPessoaController.text,
          tituloEleitor: tituloEleitoralPessoaController.text,
          zonaEleitoral: zonaEleitoralPessoaController.text,
          religiaoId: religiaoSelected.value,
          igrejaId: igrejaPessoaController.text,
          funcaoIgreja: funcaoIgrejaPessoaController.text,
          localTrabalho: localTrabalhoPessoaController.text,
          cargoTrabalho: cargoPessoaController.text,
          status: 1,
          usuarioId: leaderSelected.value,
          username: usernameSignUpCtrl.text,
          senha: passwordSignUpCtrl.text);

      mensagem = await repository.insertPeople(
          pessoa, selectedSaudeIds, selectedMedicamentoIds);

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {
            "return": 0,
            "message":
                'Seu login foi cadastrado com sucesso. Você já pode entrar no app.'
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

    return retorno;
  }

  Future<void> getLeader() async {
    listLeader.clear();
    listLeader.value = await repository.getLeader();
  }

  Future<void> getMaritalStatus() async {
    listMaritalStatus.clear();
    listMaritalStatus.value = await repository.getMaritalStatus();
  }

  Future<void> getReligion() async {
    listReligion.clear();
    listReligion.value = await repository.getReligion();
  }

  Future<void> getChurch() async {
    listChurch.clear();
    listChurch.value = await repository.getChurch();

    suggestions.clear();

    for (var element in listChurch) {
      suggestions.add(element.descricao!);
    }
  }

  Future<void> getHealth() async {
    final updatedList = await repository.getHealth();
    listHealth.assignAll(updatedList);
  }

  Future<void> getMedicine() async {
    final updatedList = await repository.getMedicine();
    listMedicine.assignAll(updatedList);
  }
}
