import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucif/app/data/models/church_model.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/repository/church_repository.dart';
import 'package:ucif/app/data/repository/family_service_repository.dart';
import 'package:ucif/app/data/repository/marital_status_repository.dart';
import 'package:ucif/app/data/repository/people_repository.dart';
import 'package:ucif/app/data/repository/religion_repository.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/format_validator.dart';
import 'package:ucif/app/utils/user_storage.dart';

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

  int? idPeopleSelected;
  int? idFamilySelected;

  RxList<People> listPeoples = <People>[].obs;
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

  final repository = Get.put(PeopleRepository());
  final familyController = Get.put(FamilyController());
  final repositoryService = Get.put(FamilyServiceRepository());
  final maritalRepository = Get.find<MaritalStatusRepository>();
  final repositoryReligion = Get.put(ReligionRepository());

  RxBool isLoading = true.obs;

  Map<String, dynamic> retorno = {"return": 1, "message": ""};

  dynamic mensagem;

  final status = Get.find<InternetStatusProvider>().status;

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isLoadingMore = false;

  Widget searchChild(x) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
        child:
            Text(x, style: const TextStyle(fontSize: 18, color: Colors.black)),
      );

  @override
  void onInit() async {
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

      getPeoples();
    }

    super.onInit();
  }

  Future<void> loadMorePeoples() async {
    try {
      isLoadingMore = true;
      final token = UserStorage.getToken();
      final nextPage = currentPage + 1;
      final moreFamilies =
          await repository.getAll("Bearer $token", page: nextPage);
      if (moreFamilies.isNotEmpty) {
        for (final family in moreFamilies) {
          if (!listPeoples
              .any((existingFamily) => existingFamily.id == family.id)) {
            listPeoples.add(family);
          }
        }
        currentPage = nextPage;
      } else {}
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> searchPeople(String query) async {
    try {
      if (query.isEmpty) {
        await getPeoples(); // Aqui você deve implementar sua lógica para buscar as famílias
      } else {
        final filteredFamilies = listPeoples
            .where((family) =>
                family.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        listPeoples.assignAll(filteredFamilies);
      }
    } catch (error) {
      throw Exception('Erro ao buscar famílias: $error');
    }
  }

  Future<void> getPeoples({int? page}) async {
    isLoading.value = true;
    try {
      final token = UserStorage.getToken();
      listPeoples.value = await repository.getAll("Bearer $token", page: page);
      update();
    } catch (e) {
      throw Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> savePeople(
      Family family, bool peopleLocal) async {
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
        familiaId: family.id,
        foto: imagePath,
      );

      final token = box.read('auth')['access_token'];

      mensagem = await repository.insertPeople(
          "Bearer $token", pessoa, File(photoUrlPath.value), peopleLocal);

      print(mensagem);

      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
          familyController.getFamilies();
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

      familyController.getFamilies();
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
      listReligion.clear();
      final token = UserStorage.getToken();
      final updatedList = await repositoryReligion.getAll("Bearer $token");
      listReligion.assignAll(updatedList);
    }
  }

  Future<void> getChurch() async {
    if (UserStorage.existUser()) {
      listChurch.clear();
      final token = UserStorage.getToken();
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
    nascimentoPessoaController.text = selectedPeople!.dataNascimento.toString();
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
    photoUrlPath.value = selectedPeople!.foto!;
    oldImagePath.value = selectedPeople!.foto!;
    redeSocialPessoaController.text = selectedPeople!.redeSocial!;
    isImagePicPathSet.value = false;
    provedorCheckboxValue.value =
        selectedPeople!.provedorCasa! == 'sim' ? true : false;

    // Verifique se o caminho da imagem local está definido
    if (photoUrlPath.value.isNotEmpty) {
      // Defina a imagem usando FileImage para exibir localmente
      isImagePicPathSet.value = true;
      photoUrlPath.value = selectedPeople!.foto!;
    } else {
      // Caso contrário, defina para false e exiba a imagem padrão
      isImagePicPathSet.value = false;
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

  Future<Map<String, dynamic>> updateService(int id) async {
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
    idPeopleSelected = null;
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
