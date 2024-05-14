import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/models/church_model.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/repository/church_repository.dart';
import 'package:ucif/app/data/repository/family_service_repository.dart';
import 'package:ucif/app/data/repository/marital_status_repository.dart';
import 'package:ucif/app/data/repository/people_repository.dart';
import 'package:ucif/app/data/repository/religion_repository.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/format_validator.dart';
import 'package:ucif/app/utils/user_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleController extends GetxController {
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

  TextEditingController searchController = TextEditingController();

  var photoUrlPath = ''.obs;
  var isImagePicPathSet = false.obs;

  final GlobalKey<FormState> peopleFormKey = GlobalKey<FormState>();
  RxBool provedorCheckboxValue = false.obs;
  RxString sexo = 'Masculino'.obs;
  RxInt estadoCivilSelected = 1.obs;
  RxInt religiaoSelected = 1.obs;
  RxString parentesco = 'Pai'.obs;
  RxString oldImagePath = ''.obs;

  // int? idPeopleSelected;
  int? idFamilySelected;

  RxList<People> listPeoples = <People>[].obs;
  RxList<People> listPeopleFamilies = <People>[].obs;
  RxList<People> listFamilyMembers = <People>[].obs;
  final repositoryChurch = Get.put(ChurchRepository());
  final box = GetStorage('credenciado');
  RxList<MaritalStatus> listMaritalStatus = <MaritalStatus>[].obs;
  RxList<Religion> listReligion = <Religion>[].obs;
  RxList<People> composicaoFamiliar = <People>[].obs;
  RxList<Church> listChurch = <Church>[].obs;
  int suggestionsCount = 12;
  final focus = FocusNode();
  List<String> suggestions = [];

  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  People? selectedPeople;
  FamilyService? selectedService;

  User? selectedUser;

  final repository = Get.put(PeopleRepository());
  final familyController = Get.put(FamilyController());
  final repositoryService = Get.put(FamilyServiceRepository());
  final maritalRepository = Get.find<MaritalStatusRepository>();
  final repositoryReligion = Get.put(ReligionRepository());

  RxBool isLoading = true.obs;

  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  RxBool isSaving = false.obs;

  dynamic mensagem;

  final status = Get.find<InternetStatusProvider>().status;

  final ScrollController scrollController = ScrollController();
  final ScrollController scrollFilterPeople = ScrollController();

  int currentPage = 1;
  bool isLoadingMore = false;

  Widget searchChild(x) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
        child:
            Text(x, style: const TextStyle(fontSize: 18, color: Colors.black)),
      );

  @override
  void onInit() async {
    // print(
    //     '======================================================controller PEOPLE==============');
    if (UserStorage.existUser()) {
      bool isConnected = await ConnectionStatus.verifyConnection();
      if (isConnected) {
        Future.wait([
          getMaritalStatus(),
          getPeoples(),
          getReligion(),
          getChurch(),
        ]);
      }

      final internetStatusProvider = Get.find<InternetStatusProvider>();
      final statusStream = internetStatusProvider.statusStream;
      statusStream.listen((status) {
        if (status == InternetStatus.connected) {
          Future.wait([
            getMaritalStatus(),
            getPeoples(),
            getReligion(),
            getChurch(),
          ]);
        }
      });

      if (Get.arguments != null) {
        var sexo = Get.arguments;
        RxList<People> pessoasFiltradas =
            listPeoples.where((pessoa) => pessoa.sexo == sexo).toList().obs;
        listPeoples.assignAll(pessoasFiltradas);
      }
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (!isLoadingMore) {
            loadMorePeoples().then((value) => isLoading.value = false);
          }
        }
      });
      scrollFilterPeople.addListener(() {
        if (scrollFilterPeople.position.pixels ==
            scrollFilterPeople.position.maxScrollExtent) {
          if (!isLoadingMore) {
            loadMorePeoplesFiltered().then((value) => isLoading.value = false);
          }
        }
      });

      getPeoples();
    }

    super.onInit();
  }

  @override
  void onClose() {
    searchController.text = '';
    super.onClose();
  }

  Future<void> loadMorePeoples() async {
    try {
      final token = UserStorage.getToken();
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      final morePeoples = await repository.getAll("Bearer $token",
          page: nextPage,
          search:
              searchController.text.isNotEmpty ? searchController.text : null);
      if (morePeoples.isNotEmpty) {
        for (final people in morePeoples) {
          if (!listPeoples
              .any((existingFamily) => existingFamily.id == people.id)) {
            listPeoples.add(people);
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

  Future<void> loadMorePeoplesFiltered() async {
    try {
      final token = UserStorage.getToken();
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      final morePeoples = await repository
          .getAllFilter("Bearer $token", selectedUser!, page: nextPage);
      if (morePeoples.isNotEmpty) {
        for (final people in morePeoples['data'] as List) {
          if (!listPeopleFamilies
              .any((existingFamily) => existingFamily.id == people['id'])) {
            listPeopleFamilies.add(People.fromJson(people));
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

  void searchPeople(String query) async {
    try {
      if (query.isEmpty) {
        await getPeoples();
      } else {
        final filteredFamilies = listPeoples
            .where((family) =>
                family.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        listPeoples.assignAll(filteredFamilies);
      }
    } catch (error) {
      ErrorHandler.showError(error);
    } finally {
      if (query.isEmpty) {
        loadMorePeoples(); // Carrega mais famílias quando a pesquisa é limpa
      }
    }
  }

  Future<void> getPeoples({int? page, String? search}) async {
    isLoading.value = true;
    try {
      final token = UserStorage.getToken();
      listPeoples.value =
          await repository.getAll("Bearer $token", page: page, search: search);
      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }

  Future<void> getFamilyMembers(int? familiaId) async {
    isLoading.value = true;
    try {
      final token = UserStorage.getToken();
      listFamilyMembers.value =
          await repository.getAllMember("Bearer $token", familiaId);

      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }

  Future<void> getPeoplesFilter(User user) async {
    isLoading.value = true;
    try {
      final token = UserStorage.getToken();
      var response = await repository.getAllFilter("Bearer $token", user);
      listPeopleFamilies.value = (response['data'] as List)
          .map((familiaJson) => People.fromJson(familiaJson))
          .toList();

      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }

  setSelectedUser(User user) {
    selectedUser = user;
  }

  whatsapp(String phoneNumber) async {
    var contact = phoneNumber;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Get.snackbar('Falha', 'Whatsapp não instalado!',
          backgroundColor: Colors.red.shade500,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<Map<String, dynamic>> savePeople(
      Family? family, bool peopleLocal) async {
    if (peopleFormKey.currentState!.validate()) {
      String imagePath = photoUrlPath.value;

      People pessoa = People(
        nome: nomePessoaController.text,
        cpf: cpfPessoaController.text,
        estadoCivilId: estadoCivilSelected.value,
        parentesco: parentesco.value,
        provedorCasa: provedorCheckboxValue.value ? 'sim' : 'nao',
        sexo: sexo.value,
        dataNascimento: nascimentoPessoaController.text,
        tituloEleitor: tituloEleitoralPessoaController.text,
        zonaEleitoral: zonaEleitoralPessoaController.text,
        localTrabalho: localTrabalhoPessoaController.text,
        cargoTrabalho: cargoPessoaController.text,
        telefone: celularPessoaController.text,
        redeSocial: redeSocialPessoaController.text,
        religiaoId: religiaoSelected.value,
        igrejaId: igrejaPessoaController.text,
        funcaoIgreja: funcaoIgrejaPessoaController.text,
        status: 1,
        usuarioId: box.read('auth')['user']['id'],
        familiaId: family?.id,
        foto: imagePath,
      );

      final token = box.read('auth')['access_token'];

      mensagem = await repository.insertPeople(
          "Bearer $token", pessoa, File(photoUrlPath.value), peopleLocal);

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
          familyController.getFamilies(page: 1);
        }
      } else if (mensagem['message'] == 'ja_existe') {
        retorno = {
          "return": 1,
          "message": "Já existe um usuário com esse e-mail!"
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

  Future<Map<String, dynamic>> updatePeople(bool peopleLocal) async {
    if (peopleFormKey.currentState!.validate()) {
      String imagePath = photoUrlPath.value;
      People pessoa = People(
          id: int.parse(idPessoaController.text),
          nome: nomePessoaController.text,
          cpf: cpfPessoaController.text,
          estadoCivilId: estadoCivilSelected.value,
          parentesco: parentesco.value,
          provedorCasa: provedorCheckboxValue.value ? 'sim' : 'nao',
          sexo: sexo.value,
          dataNascimento: nascimentoPessoaController.text,
          tituloEleitor: tituloEleitoralPessoaController.text,
          zonaEleitoral: zonaEleitoralPessoaController.text,
          localTrabalho: localTrabalhoPessoaController.text,
          cargoTrabalho: cargoPessoaController.text,
          telefone: celularPessoaController.text,
          redeSocial: redeSocialPessoaController.text,
          religiaoId: religiaoSelected.value,
          igrejaId: igrejaPessoaController.text,
          funcaoIgreja: funcaoIgrejaPessoaController.text,
          status: 1,
          usuarioId: UserStorage.getUserId(),
          foto: imagePath,
          familiaId: int.parse(familiaId.text));
      final token = UserStorage.getToken();
      final mensagem = await repository.updatePeople("Bearer $token", pessoa,
          File(photoUrlPath.value), oldImagePath.value, peopleLocal);

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        } else if (mensagem['message'] == 'ja_existe') {
          retorno = {
            "return": 1,
            "message": "Já existe uma pessoa com esse cpf!"
          };
        }
      }

      familyController.getFamilies(page: 1);
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  Future<Map<String, dynamic>> changePeopleFamily(int familyId, int id) async {
    People pessoa = People(familiaId: familyId, id: id);
    final token = box.read('auth')['access_token'];

    final mensagem =
        await repository.changePeopleFamily("Bearer $token", pessoa);

    if (mensagem != null) {
      if (mensagem['message'] == 'success') {
        retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        getPeoples();
      } else if (mensagem['message'] == 'ja_existe') {
        retorno = {
          "return": 1,
          "message": "Já existe uma pessoa com esse cpf!"
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

  void removePeople(People pessoa) {
    composicaoFamiliar.remove(pessoa);
  }

  void clearPeopleModal() {
    peopleFormKey.currentState!.reset();
  }

  Future<void> getMaritalStatus() async {
    if (UserStorage.existUser()) {
      final token = UserStorage.getToken();
      final updatedList = await maritalRepository.getAll("Bearer $token");
      listMaritalStatus.assignAll(updatedList);
    }
  }

  Future<void> getReligion() async {
    if (UserStorage.existUser()) {
      final token = UserStorage.getToken();
      listReligion.clear();
      final updatedList = await repositoryReligion.getAll("Bearer $token");
      listReligion.assignAll(updatedList);
    }
  }

  Future<void> getChurch() async {
    if (UserStorage.existUser()) {
      final token = UserStorage.getToken();
      listChurch.clear();
      listChurch.value = await repositoryChurch.getAll("Bearer $token");

      suggestions.clear();

      for (var element in listChurch) {
        suggestions.add(element.descricao!);
      }
    }
  }

  void fillInFieldsForEditPerson() {
    idPessoaController.text = selectedPeople!.id.toString();
    nomePessoaController.text = selectedPeople!.nome.toString();
    final DateTime data =
        DateTime.parse(selectedPeople!.dataNascimento.toString());
    final String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
    nascimentoPessoaController.text = dataFormatada.toString();
    cpfPessoaController.text = selectedPeople!.cpf.toString();
    tituloEleitoralPessoaController.text =
        selectedPeople!.tituloEleitor.toString();
    zonaEleitoralPessoaController.text =
        selectedPeople!.zonaEleitoral.toString();
    celularPessoaController.text = selectedPeople!.telefone.toString();
    localTrabalhoPessoaController.text =
        selectedPeople!.localTrabalho.toString();
    cargoPessoaController.text = selectedPeople!.cargoTrabalho.toString();
    funcaoIgrejaPessoaController.text = selectedPeople!.funcaoIgreja.toString();
    statusPessoaController.text = selectedPeople!.status.toString();
    usuarioId.text = selectedPeople!.usuarioId.toString();
    familiaId.text = selectedPeople!.familiaId.toString();
    igrejaPessoaController.text = selectedPeople!.igrejaId.toString();
    estadoCivilSelected.value = selectedPeople!.estadoCivilId!;
    parentesco.value = selectedPeople!.parentesco!;
    sexo.value = selectedPeople!.sexo!;
    religiaoSelected.value = selectedPeople!.religiaoId!;
    photoUrlPath.value = selectedPeople!.foto ?? '';
    oldImagePath.value = selectedPeople!.foto ?? '';
    redeSocialPessoaController.text = selectedPeople!.redeSocial ?? '';
    isImagePicPathSet.value = false;
    provedorCheckboxValue.value =
        selectedPeople!.provedorCasa! == 'sim' ? true : false;

    // Verifique se o caminho da imagem local está definido
    if (photoUrlPath.value.isNotEmpty) {
      // Defina a imagem usando FileImage para exibir localmente
      isImagePicPathSet.value = false;
      photoUrlPath.value = selectedPeople!.foto!;
    } else {
      // Caso contrário, defina para false e exiba a imagem padrão
      isImagePicPathSet.value = true;
    }
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

  void onNascimentoChanged(String nascimento) {
    final formattedNASCIMENTO = FormattersValidators.formatDate(nascimento);
    nascimentoPessoaController.value = TextEditingValue(
      text: formattedNASCIMENTO.value,
      selection:
          TextSelection.collapsed(offset: formattedNASCIMENTO.value.length),
    );
  }

  bool validateCPF() {
    return FormattersValidators.validateCPF(cpfPessoaController.text);
  }

  bool validatePhone() {
    return FormattersValidators.validatePhone(celularPessoaController.text);
  }

  void clearAllPeopleTextFields() {
    final textControllers = [
      idPessoaController,
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

    // Itera sobre todos os TextEditingController e limpa cada um deles
    for (final controller in textControllers) {
      controller.clear();
    }

    photoUrlPath.value = "";
  }

  //*MÉTODOS RESPONSAVEIS PELO ATENDIMENTO*/
  Future<Map<String, dynamic>> saveService(Family family) async {
    FamilyService familyService = FamilyService(
      descricao: messageController.text,
      assunto: subjectController.text,
      dataAtendimento: selectedDate.value.toString(),
      usuarioId: box.read('auth')['user']['id'],
    );

    final token = box.read('auth')['access_token'];
    dynamic mensagem;

    if (await ConnectionStatus.verifyConnection()) {
      mensagem = await repositoryService.insertService(
          "Bearer $token", familyService, family);
    } else {
      //await repositoryService.saveFamilyServiceLocal(familyService);
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
    getPeoples();
    return retorno;
  }

  Future<Map<String, dynamic>> updateService(
      int id, int idPeopleSelected) async {
    FamilyService familyService = FamilyService(
      descricao: messageController.text,
      assunto: subjectController.text,
      dataAtendimento: selectedDate.value.toString(),
      pessoaId: idPeopleSelected,
      usuarioId: box.read('auth')['user']['id'],
      id: id,
    );

    final token = box.read('auth')['access_token'];

    final mensagem =
        await repositoryService.updateService("Bearer $token", familyService);

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

    getPeoples();

    return retorno;
  }

  void clearModalMessageService() {
    subjectController.value = TextEditingValue.empty;
    messageController.value = TextEditingValue.empty;
    selectedDate.value = null;
    idFamilySelected = null;
    // idPeopleSelected = null;
  }

  void fillInFieldsServicePerson() {
    subjectController.text = selectedService!.assunto.toString();
    messageController.text = selectedService!.descricao.toString();

    if (selectedService!.dataCadastro != null) {
      selectedDate.value = DateTime.parse(selectedService!.dataAtendimento!);
    } else {
      selectedDate.value = DateTime.now();
    }
  }
}
