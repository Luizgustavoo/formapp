// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/via_cep.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/data/repository/family_service_repository.dart';
import 'package:formapp/app/utils/format_validator.dart';
import 'package:formapp/app/utils/internet_connection_status.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyController extends GetxController
    with SingleGetTickerProviderMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController idFamiliaController = TextEditingController();
  TextEditingController nomeFamiliaController = TextEditingController();
  TextEditingController cepFamiliaController = TextEditingController();
  TextEditingController ruaFamiliaController = TextEditingController();
  TextEditingController numeroCasaFamiliaController = TextEditingController();
  TextEditingController bairroFamiliaController = TextEditingController();
  TextEditingController cidadeFamiliaController = TextEditingController();
  TextEditingController ufFamiliaController = TextEditingController();
  TextEditingController complementoFamiliaController = TextEditingController();
  TextEditingController residenciaPropriaFamiliaController =
      TextEditingController();
  TextEditingController statusFamiliaController = TextEditingController();

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  int? idPeopleSelected;
  int? idFamilySelected;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  RxInt typeOperation = 1.obs; // 1 - Inserir | 2 - Atualizar

  final box = GetStorage('credenciado');
  Family? selectedFamily;
  List<People>? listPessoas = [];

  RxInt tabIndex = 0.obs;
  RxList<Family> listFamilies = <Family>[].obs;
  TabController? tabController;
  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();

  RxBool residenceOwn = false.obs;
  RxBool familyInfo = true.obs;
  RxBool isExpanded = false.obs;

  final repository = Get.find<FamilyRepository>();
  final repositoryService = Get.find<FamilyServiceRepository>();

  Animation<double>? animation;
  AnimationController? animationController;
  dynamic mensagem;

  @override
  void onInit() {
    getFamilies();
    super.onInit();
  }

  @override
  void onClose() {
    getFamilies();
    super.onClose();
  }

  void searchFamily(String query) {
    if (query.isEmpty) {
      getFamilies();
    } else {
      listFamilies.assignAll(listFamilies
          .where((family) =>
              family.nome!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void fillInFields() {
    idFamiliaController.text = selectedFamily!.id.toString();
    nomeFamiliaController.text = selectedFamily!.nome.toString();
    cepFamiliaController.text = selectedFamily!.cep.toString();
    ruaFamiliaController.text = selectedFamily!.endereco.toString();
    numeroCasaFamiliaController.text = selectedFamily!.numeroCasa.toString();
    bairroFamiliaController.text = selectedFamily!.bairro.toString();
    cidadeFamiliaController.text = selectedFamily!.cidade.toString();
    ufFamiliaController.text = selectedFamily!.uf.toString();
    complementoFamiliaController.text = selectedFamily!.complemento.toString();
    residenciaPropriaFamiliaController.text =
        selectedFamily!.residenciaPropria.toString();
    statusFamiliaController.text = selectedFamily!.status.toString();
  }

  Future<Map<String, dynamic>> saveFamily() async {
    Map<String, dynamic> retorno = {"return": 1, "message": ""};

    if (familyFormKey.currentState!.validate()) {
      Family family = Family(
        nome: nomeFamiliaController.text,
        cep: cepFamiliaController.text,
        endereco: ruaFamiliaController.text,
        complemento: complementoFamiliaController.text,
        bairro: bairroFamiliaController.text,
        numeroCasa: numeroCasaFamiliaController.text,
        cidade: cidadeFamiliaController.text,
        uf: ufFamiliaController.text,
        residenciaPropria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuarioId: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      if (await ConnectionStatus.verificarConexao()) {
        mensagem = await repository.insertFamily("Bearer " + token, family);
      } else {
        await repository.saveFamilyLocal(family);
      }

      getFamilies();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateFamily(int id) async {
    Map<String, dynamic> retorno = {"return": 1, "message": ""};

    if (familyFormKey.currentState!.validate()) {
      Family family = Family(
        id: id,
        nome: nomeFamiliaController.text,
        cep: cepFamiliaController.text,
        endereco: ruaFamiliaController.text,
        complemento: complementoFamiliaController.text,
        bairro: bairroFamiliaController.text,
        numeroCasa: numeroCasaFamiliaController.text,
        cidade: cidadeFamiliaController.text,
        uf: ufFamiliaController.text,
        residenciaPropria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuarioId: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      final mensagem = await repository.updateFamily("Bearer " + token, family);

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

      getFamilies();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  void getFamilies() async {
    final token = box.read('auth')['access_token'];
    listFamilies.value = await repository.getAll("Bearer " + token);
  }

  void clearAllFamilyTextFields() {
    // Lista de todos os TextEditingController
    final textControllers = [
      idFamiliaController,
      nomeFamiliaController,
      cepFamiliaController,
      ruaFamiliaController,
      numeroCasaFamiliaController,
      bairroFamiliaController,
      cidadeFamiliaController,
      ufFamiliaController,
      complementoFamiliaController,
      residenciaPropriaFamiliaController,
      statusFamiliaController,
    ];

    // Itera sobre todos os TextEditingController e limpa cada um deles
    for (final controller in textControllers) {
      controller.clear();
    }
  }

  /*PARTE RESPONSAVEL PELO CEP */
  void searchCEP() async {
    final cep = cepFamiliaController.text;
    final addressData = await ViaCEPService.getAddressFromCEP(cep);

    if (addressData.containsKey('error')) {
      Get.snackbar(
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          'Erro',
          'Erro ao obter dados do CEP: ${addressData['error']}');
      clearCEP();
    } else {
      ruaFamiliaController.text = addressData['logradouro'];
      bairroFamiliaController.text = addressData['bairro'];
      cidadeFamiliaController.text = addressData['localidade'];
      ufFamiliaController.text = addressData['uf'];
    }
  }

  void clearCEP() {
    ruaFamiliaController.text = '';
    cidadeFamiliaController.text = '';
    bairroFamiliaController.text = '';
    ufFamiliaController.text = '';
    complementoFamiliaController.text = '';
    numeroCasaFamiliaController.text = '';
  }

  void clearModalMessageService() {
    subjectController.value = TextEditingValue.empty;
    messageController.value = TextEditingValue.empty;
    selectedDate.value = null;
    idFamilySelected = null;
    idPeopleSelected = null;
  }
  /*FINAL PARTE RESPONSAVEL PELO CEP */

  /*PARTE RESPONSAVEL PELA FORMATACAO*/
  void onCEPChanged(String cep) {
    final formattedCEP = FormattersValidators.formatCEP(cep);
    cepFamiliaController.value = TextEditingValue(
      text: formattedCEP.value,
      selection: TextSelection.collapsed(offset: formattedCEP.value.length),
    );
  }

  bool validateCEP() {
    return FormattersValidators.validateCEP(cepFamiliaController.text);
  }

  //*MÉTODOS RESPONSAVEIS PELO ATENDIMENTO*/
  Future<Map<String, dynamic>> saveService() async {
    Map<String, dynamic> retorno = {"return": 1, "message": ""};

    FamilyService familyService = FamilyService(
      descricao: messageController.text,
      assunto: subjectController.text,
      dataAtendimento: selectedDate.value.toString(),
      pessoaId: idPeopleSelected,
      usuarioId: box.read('auth')['user']['id'],
    );

    final token = box.read('auth')['access_token'];
    dynamic mensagem;

    if (await ConnectionStatus.verificarConexao()) {
      mensagem = await repositoryService.insertService(
          "Bearer " + token, familyService);
    } else {
      await repositoryService.saveFamilyServiceLocal(familyService);
    }

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

    getFamilies();

    return retorno;
  }

  /// TESTE
  List<Family> selectedFamilies = <Family>[].obs;

  bool isSelected(Family family) {
    return selectedFamilies.contains(family);
  }

// Método para alternar a seleção de uma família
  void toggleFamilySelection(Family family) {
    if (isSelected(family)) {
      selectedFamilies.remove(family);
    } else {
      selectedFamilies.add(family);
    }
  }

  void confirmFamilySelection() {
    print('Famílias selecionadas:');
    for (Family family in selectedFamilies) {
      print(family.nome);
    }

    selectedFamilies.clear();
  }
}
