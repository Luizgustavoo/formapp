import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/via_cep.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/utils/format_validator.dart';
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

  final box = GetStorage('credenciado');
  Family? selectedFamily;
  List<Pessoas>? listPessoas = [];

  RxInt tabIndex = 0.obs;
  RxList<Family> listFamilies = <Family>[].obs;
  TabController? tabController;
  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();

  RxBool residenceOwn = false.obs;
  RxBool familyInfo = true.obs;
  final repository = Get.find<FamilyRepository>();

  Animation<double>? animation;
  AnimationController? animationController;

  final uploadList = <MultipartFile>[];

  List<Map<String, FileImage>>? imageFileList = [];

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      tabIndex.value = tabController!.index;
    });

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
              family.nome!.toLowerCase().contains(query.toLowerCase()) ||
              family.pessoas![0].provedor_casa!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList());
    }
  }

  void fillInFields() {
    idFamiliaController.text = selectedFamily!.id.toString();
    nomeFamiliaController.text = selectedFamily!.nome.toString();
    cepFamiliaController.text = selectedFamily!.cep.toString();
    ruaFamiliaController.text = selectedFamily!.endereco.toString();
    numeroCasaFamiliaController.text = selectedFamily!.numero_casa.toString();
    bairroFamiliaController.text = selectedFamily!.bairro.toString();
    cidadeFamiliaController.text = selectedFamily!.cidade.toString();
    ufFamiliaController.text = selectedFamily!.uf.toString();
    complementoFamiliaController.text = selectedFamily!.complemento.toString();
    residenciaPropriaFamiliaController.text =
        selectedFamily!.residencia_propria.toString();
    statusFamiliaController.text = selectedFamily!.status.toString();

    listPessoas = selectedFamily!.pessoas;
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
        numero_casa: numeroCasaFamiliaController.text,
        cidade: cidadeFamiliaController.text,
        uf: ufFamiliaController.text,
        residencia_propria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuario_id: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      final mensagem = await repository.insertFamily("Bearer " + token, family);

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

      print(mensagem);

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
}
