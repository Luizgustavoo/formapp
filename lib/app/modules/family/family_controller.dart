import 'package:flutter/material.dart';
import 'package:formapp/app/data/database_helper.dart';
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

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
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
  final DatabaseHelper localDatabase = DatabaseHelper();

  Animation<double>? animation;
  AnimationController? animationController;

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
              family.pessoas![0].provedorCasa!
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
        numero_casa: numeroCasaFamiliaController.text,
        cidade: cidadeFamiliaController.text,
        uf: ufFamiliaController.text,
        residencia_propria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuario_id: box.read('auth')['user']['id'],
      );

      final token = box.read('auth')['access_token'];

      final mensagem = await repository.updateFamily("Bearer " + token, family);
      print(mensagem);
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

  /*SALVAR DADOS OFFLINE DA FAMILIA */
  Future<void> saveFamilyLocally(Map<String, dynamic> familyData) async {
    await localDatabase.insertFamily(familyData);
    final resposta = await localDatabase.getAllFamilies();
    print(resposta);
  }

  Future<List<Map<String, dynamic>>> getAllFamiliesLocally() async {
    return await localDatabase.getAllFamilies();
  }

  Future<void> saveFamilyLocal() async {
    final familyData = {
      'nome': nomeFamiliaController.text,
      'endereco': ruaFamiliaController.text,
      'numero_casa': numeroCasaFamiliaController.text,
      'bairro': bairroFamiliaController.text,
      'cidade': cidadeFamiliaController.text,
      'uf': ufFamiliaController.text,
      'complemento': complementoFamiliaController.text,
      'residencia_propria': residenceOwn.value ? 'sim' : 'nao',
      'usuario_id': box.read('auth')['user']['id'],
      'status': 1,
      'cep': cepFamiliaController.text,
    };

    // Se não houver conectividade, salva localmente
    await saveFamilyLocally(familyData);
  }
}
