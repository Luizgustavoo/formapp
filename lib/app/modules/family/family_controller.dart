import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/provider/via_cep.dart';
import 'package:ucif/app/data/repository/family_repository.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/format_validator.dart';
import 'package:ucif/app/utils/user_storage.dart';

class FamilyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerModal = TextEditingController();
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
  RxList<Family> listFamilyPeoples = <Family>[].obs;
  RxList<People> listPeoples = <People>[].obs;
  RxList<Family> listFamiliesDropDown = <Family>[].obs;
  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();

  RxBool residenceOwn = false.obs;
  RxBool familyInfo = true.obs;
  RxBool isExpanded = false.obs;

  RxString uf = 'AC'.obs;

  final repository = Get.put(FamilyRepository());

  Animation<double>? animation;
  AnimationController? animationController;
  dynamic mensagem;

  final DatabaseHelper localDatabase = DatabaseHelper();
  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  final status = Get.find<InternetStatusProvider>().status;

  User? selectedUser;
  final showCaseViewShown = false.obs;

  RxBool isLoadingFamilies = false.obs;
  RxBool isLoadingFamiliesFiltered = false.obs;

  Rx<Color> corFundoScaffold = Colors.white.obs;

  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerModal = ScrollController();
  final ScrollController scrollFilterFamily = ScrollController();

  int currentPage = 1;
  bool isLoadingMore = false;

  User userSelected = User();
  RxString totalFamily = ''.obs;
  RxString totalPeoples = ''.obs;
  RxString totalMale = ''.obs;
  RxString totalFemale = ''.obs;
  RxString totalNoSex = ''.obs;

  @override
  void onInit() {
    if (UserStorage.existUser()) {

      Future.wait([
      getFamilies(),
      ]);

      final internetStatusProvider = Get.find<InternetStatusProvider>();
      final statusStream = internetStatusProvider.statusStream;
      statusStream.listen((status) {
        if (status == InternetStatus.connected) {
          Future.wait([
            getFamilies(),
          ]);
        }
      });



    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoadingMore) {
          loadMoreFamilies().then((value) => isLoadingFamilies.value = false);
        }
      }
    });
    scrollControllerModal.addListener(() {
      if (scrollControllerModal.position.pixels ==
          scrollControllerModal.position.maxScrollExtent) {
        if (!isLoadingMore) {
          loadMoreFamilies().then((value) => isLoadingFamilies.value = false);
        }
      }
    });
    scrollFilterFamily.addListener(() {
      if (scrollFilterFamily.position.pixels ==
          scrollFilterFamily.position.maxScrollExtent) {
        if (!isLoadingMore) {
          loadMoreFamiliesFiltered()
              .then((value) => isLoadingFamiliesFiltered.value = false);
        }
      }
    });

    super.onInit();
  }

  Future<void> loadMoreFamilies() async {
    try {
      String? search;
      if (searchController.text.isNotEmpty) {
        search = searchController.text;
      } else if (searchControllerModal.text.isNotEmpty) {
        search = searchControllerModal.text;
      }
      final token = UserStorage.getToken();
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      final moreFamilies = await repository.getAll("Bearer $token",
          page: nextPage, search: search);
      if (moreFamilies.isNotEmpty) {
        for (final family in moreFamilies) {
          if (!listFamilies
              .any((existingFamily) => existingFamily.id == family.id)) {
            listFamilies.add(family);
          }
        }
        currentPage = nextPage;
      }
    } catch (e) {
      ErrorHandler.showError(e);
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> loadMoreFamiliesFiltered() async {
    try {
      final token = UserStorage.getToken();
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      final moreFamilies = await repository
          .getAllFilter("Bearer $token", selectedUser!, page: nextPage);
      if (moreFamilies.isNotEmpty) {
        for (final people in moreFamilies['pessoas']['data'] as List) {
          if (!listPeoples
              .any((existingPeople) => existingPeople.id == people['id'])) {
            listPeoples.add(People.fromJson(people));
          }
        }
        currentPage = nextPage;
      }
    } catch (e) {
      ErrorHandler.showError(e);
    } finally {
      isLoadingMore = false;
    }
  }

  void searchFamily(String query) async {
    try {
      if (query.isEmpty) {
        await getFamilies();
      } else {
        final filteredFamilies = listFamilies
            .where((family) =>
                family.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        listFamilies.assignAll(filteredFamilies);
      }
    } catch (error) {
      ErrorHandler.showError(error);
    } finally {
      if (query.isEmpty) {
        loadMoreFamilies(); // Carrega mais famílias quando a pesquisa é limpa
      }
    }
  }

  Future<void> getFamilies({int? page, String? search}) async {
    isLoadingFamilies.value = true;
    try {
      final token = UserStorage.getToken();
      listFamilies.value =
          await repository.getAll("Bearer $token", page: page, search: search);
      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoadingFamilies.value = false;
  }

  Future<void> getFamiliesDropDown() async {
    isLoadingFamilies.value = true;
    try {
      final token = UserStorage.getToken();
      listFamiliesDropDown.value =
          await repository.getAllDropDown("Bearer $token");
      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoadingFamilies.value = false;
  }

  Future<void> getFamiliesFilter(User lider) async {
    isLoadingFamiliesFiltered.value = true;
    try {
      final token = UserStorage.getToken();
      var response = await repository.getAllFilter("Bearer $token", lider);

      listFamilyPeoples.value = (response['familias']['data'] as List)
          .map((familiaJson) => Family.fromJson(familiaJson))
          .toList();
      listPeoples.value = (response['pessoas']['data'] as List)
          .map((pessoaJson) => People.fromJson(pessoaJson))
          .toList();

      totalFamily.value = response['total_familias'].toString();
      totalPeoples.value = response['total_pessoas'].toString();
      totalMale.value = response['total_masculino'].toString();
      totalFemale.value = response['total_feminino'].toString();
      totalNoSex.value = response['total_sem_sexo'].toString();

      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoadingFamiliesFiltered.value = false;
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
      mensagem = await repository.insertFamily("Bearer $token", family);
      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
          getFamilies();
        }
      } else if (mensagem['message'] == 'ja_existe') {
        retorno = {
          "return": 1,
          "message": "Já existe uma família com esse nome!"
        };
      }
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateFamily(int id, bool familyLocal) async {
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
      final mensagem =
          await repository.updateFamily("Bearer $token", family, familyLocal);

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

  deleteFamily(int id, bool familyLocal) async {
    Family family = Family(
      id: id,
    );
    final token = UserStorage.getToken();
    mensagem =
        await repository.deleteFamily("Bearer $token", family, familyLocal);

    getFamilies();

    return mensagem;
  }

  Future<Map<String, dynamic>> sendFamilyToAPIOffline(Family family) async {
    try {
      if (await ConnectionStatus.verifyConnection()) {
        final token = UserStorage.getToken();
        var mensagem =
            await repository.insertFamilyLocalToAPi("Bearer $token", family);

        if (mensagem != null) {
          if (mensagem['message'] == 'success') {
            deleteFamily(family.id!, true);
            retorno = {
              "return": 0,
              "message": "Operação realizada com sucesso!"
            };
          } else if (mensagem['message'] == 'ja_existe') {
            retorno = {
              "return": 1,
              "message": "Já existe uam família com esse nome!"
            };
          } else {
            retorno = {"return": 1, "message": "Falha!"};
          }
        }
        getFamilies();
      }
    } catch (e) {
      ErrorHandler.showError(e);
    }
    return retorno;
  }

  void clearAllFamilyTextFields() {
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

  void searchCEP() async {
    bool isConnected = await ConnectionStatus.verifyConnection();

    if (isConnected && cepFamiliaController.text.isNotEmpty) {
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
  }

  void clearCEP() {
    ruaFamiliaController.text = '';
    cidadeFamiliaController.text = '';
    bairroFamiliaController.text = '';
    uf.value = '';
    complementoFamiliaController.text = '';
    numeroCasaFamiliaController.text = '';
  }

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
