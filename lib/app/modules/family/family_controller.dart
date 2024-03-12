import 'package:flutter/material.dart';
import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/internet_status_provider.dart';
import 'package:formapp/app/data/provider/via_cep.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/utils/format_validator.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

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
  TextEditingController complementoFamiliaController = TextEditingController();
  TextEditingController residenciaPropriaFamiliaController =
      TextEditingController();
  TextEditingController statusFamiliaController = TextEditingController();

  RxInt typeOperation = 1.obs;

  RxString filtroUsuario = "".obs;

  final box = GetStorage('credenciado');
  Family? selectedFamily;
  List<People>? listPessoas = [];

  RxList<Family> listFamilies = <Family>[].obs;
  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();

  RxBool residenceOwn = false.obs;
  RxBool familyInfo = true.obs;
  RxBool isExpanded = false.obs;

  RxString uf = 'AC'.obs;

  final repository = Get.put(FamilyRepository());

  Animation<double>? animation;
  AnimationController? animationController;
  dynamic mensagem;

  GlobalKey editFamily = GlobalKey();
  GlobalKey messageFamily = GlobalKey();
  GlobalKey addFamily = GlobalKey();
  GlobalKey supportFamily = GlobalKey();
  GlobalKey addMember = GlobalKey();
  GlobalKey disableFamily = GlobalKey();

  final DatabaseHelper localDatabase = DatabaseHelper();
  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  final status = Get.find<InternetStatusProvider>().status;

  final showCaseViewShown = false.obs;

  dynamic context = Get.context;

  @override
  void onInit() {
    if (UserStorage.existUser()) {
      final internetStatusProvider = Get.find<InternetStatusProvider>();
      final statusStream = internetStatusProvider.statusStream;
      statusStream.listen((status) {
        if (status == InternetStatus.connected) {
          getFamilies();
        }
      });
      getFamilies();

      // int idLogado = box.read('auth')['user']['id'];

      // List storedUserIds = StorageManager.getUserIds();

      checkShowcase();
    }

    super.onInit();
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

  void searchFamilyUserId(String query) {
    if (query.isNotEmpty) {
      getFamilies().then((value) {
        listFamilies.assignAll(listFamilies
            .where((family) => family.usuarioId == int.parse(query))
            .toList());
      });
    }
  }

  void checkShowcase() {
    final userId = getUserId();
    final shown = box.read('showcaseShown_$userId') ?? false;
    if (!shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(Get.context!).startShowCase([
          addFamily,
          editFamily,
          messageFamily,
          supportFamily,
          addMember,
          disableFamily,
        ]);
      });
      box.write('showcaseShown_$userId', true);
    }
  }

  int getUserId() {
    final userId = box.read('userId');
    return userId ?? 0; // Ou algum valor padrão, dependendo da sua lógica
  }

  void clearShowcase() {
    final userId = getUserId();
    box.remove('showcaseShown_$userId');
  }

  Future<Map<String, dynamic>> saveFamily() async {
    if (familyFormKey.currentState!.validate()) {
      Family family = Family(
        nome: nomeFamiliaController.text,
        cep: cepFamiliaController.text,
        endereco: ruaFamiliaController.text,
        complemento: complementoFamiliaController.text,
        bairro: bairroFamiliaController.text,
        numeroCasa: numeroCasaFamiliaController.text,
        cidade: cidadeFamiliaController.text,
        uf: uf.value,
        residenciaPropria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuarioId: UserStorage.getUserId(),
      );

      final token = UserStorage.getToken();

      if (await ConnectionStatus.verifyConnection()) {
        mensagem = await repository.insertFamily("Bearer $token", family);
        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            retorno = {
              "return": 0,
              "message": "Operação realizada com sucesso!"
            };
            getFamilies();
          }
        } else if (mensagem['message'] == 'ja_existe') {
          retorno = {
            "return": 1,
            "message": "Já existe uma família com esse nome!"
          };
        }
      } else {
        mensagem = await repository.saveFamilyLocal(family);
        if (int.parse(mensagem.toString()) > 0) {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
          getFamilies();
        }
      }
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateFamily(int id) async {
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
        uf: uf.value,
        residenciaPropria: residenceOwn.value ? 'sim' : 'nao',
        status: 1,
        usuarioId: UserStorage.getUserId(),
      );

      final token = UserStorage.getToken();

      final mensagem = await repository.updateFamily("Bearer $token", family);

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

      getFamilies();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteFamily(int id) async {
    Family family = Family(
      id: id,
    );

    final token = UserStorage.getToken();

    if (await ConnectionStatus.verifyConnection()) {
      mensagem = await repository.deleteFamily("Bearer $token", family);
    } else {
      mensagem = localDatabase.delete(family.id!, 'family_table');
    }

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

    getFamilies();

    return retorno;
  }

  Future<Map<String, dynamic>> sendFamilyToAPIOffline(Family family) async {
    try {
      if (await ConnectionStatus.verifyConnection()) {
        final token = UserStorage.getToken();
        var mensagem = await repository.insertFamily("Bearer $token", family);

        await localDatabase.delete(family.id!, 'family_table');

        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            retorno = {
              "return": 0,
              "message": "Operação realizada com sucesso!"
            };
          } else if (mensagem['message'] == 'ja_existe') {
            retorno = {
              "return": 1,
              "message": "Já existe uam família com esse nome!"
            };
          }
        }
      }
      getFamilies();
    } catch (e) {
      print('Erro ao enviar dados da família para a API: $e');
    }
    return retorno;
  }

  Future<Map<String, dynamic>> sendFamilyToAPI(Family family) async {
    await sendFamilyToAPIOffline(family);
    return retorno;
  }

  Future<void> getFamilies() async {
    try {
      final token = UserStorage.getToken();
      listFamilies.value = await repository.getAll("Bearer $token");
      update();
    } catch (e) {
      print(e);
    }
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
      complementoFamiliaController,
      residenciaPropriaFamiliaController,
      statusFamiliaController,
    ];

    // Itera sobre todos os TextEditingController e limpa cada um deles
    for (final controller in textControllers) {
      controller.clear();
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
    uf.value = selectedFamily!.uf.toString();
    complementoFamiliaController.text = selectedFamily!.complemento.toString();
    residenciaPropriaFamiliaController.text =
        selectedFamily!.residenciaPropria.toString();
    statusFamiliaController.text = selectedFamily!.status.toString();
  }

  //?PARTE RESPONSAVEL PELO CEP */
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
      uf.value = addressData['uf'];
    }
  }

  void clearCEP() {
    ruaFamiliaController.text = '';
    cidadeFamiliaController.text = '';
    bairroFamiliaController.text = '';
    uf.value = '';
    complementoFamiliaController.text = '';
    numeroCasaFamiliaController.text = '';
  }
  //?FINAL DA PARTE RESPONSAVEL PELO CEP */

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
}
