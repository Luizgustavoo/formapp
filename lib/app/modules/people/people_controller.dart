import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/models/estado_civil_model.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/repository/church_repository.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/data/repository/people_repository.dart';
import 'package:formapp/app/data/repository/religion_repository.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/utils/format_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController parentescoPessoaController = TextEditingController();
  TextEditingController statusPessoaController = TextEditingController();
  TextEditingController usuarioId = TextEditingController();
  TextEditingController familiaId = TextEditingController();
  TextEditingController igrejaPessoaController = TextEditingController();

  var photoUrlPath = ''.obs;
  var isImagePicPathSet = false.obs;

  final GlobalKey<FormState> peopleFormKey = GlobalKey<FormState>();
  RxBool provedorCheckboxValue = false.obs;
  RxString sexo = 'Masculino'.obs;
  RxInt estadoCivilSelected = 1.obs;
  RxInt religiaoSelected = 1.obs;
  RxString parentesco = 'Avô(ó)'.obs;
  final repository = Get.find<MaritalStatusRepository>();
  final repositoryReligion = Get.find<ReligionRepository>();
  final repositoryChurch = Get.find<ChurchRepository>();
  final box = GetStorage('credenciado');
  RxList<EstadoCivil> listMaritalStatus = <EstadoCivil>[].obs;
  RxList<Religiao> listReligion = <Religiao>[].obs;
  RxList<Pessoas> composicaoFamiliar = <Pessoas>[].obs;
  RxList<Igreja> listChurch = <Igreja>[].obs;
  int suggestionsCount = 12;
  final focus = FocusNode();
  List<String> suggestions = [];

  final peopleRepository = Get.find<PeopleRepository>();
  final familyController = Get.find<FamilyController>();

  Widget searchChild(x) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
        child:
            Text(x, style: const TextStyle(fontSize: 18, color: Colors.black)),
      );

  Future<void> getMaritalStatus() async {
    final token = box.read('auth')['access_token'];
    final updatedList = await repository.getALl("Bearer $token");
    listMaritalStatus.assignAll(updatedList);
  }

  @override
  void onInit() async {
    await getMaritalStatus();
    getReligion();
    getChurch();
    super.onInit();
  }

  @override
  void onClose() async {
    await getMaritalStatus();
    getReligion();
    getChurch();
    super.onClose();
  }

  Future<Map<String, dynamic>> savePeople(Family family) async {
    Map<String, dynamic> retorno = {"return": 1, "message": ""};

    if (peopleFormKey.currentState!.validate()) {
      Pessoas pessoa = Pessoas(
          nome: nomePessoaController.text,
          cpf: cpfPessoaController.text,
          estadocivil_id: estadoCivilSelected.value,
          parentesco: parentesco.value,
          provedor_casa: provedorCheckboxValue.value ? 'sim' : 'nao',
          sexo: sexo.value,
          data_nascimento: nascimentoPessoaController.text,
          titulo_eleitor: tituloEleitoralPessoaController.text,
          zona_eleitoral: zonaEleitoralPessoaController.text,
          local_trabalho: localTrabalhoPessoaController.text,
          cargo_trabalho: cargoPessoaController.text,
          telefone: celularPessoaController.text,
          rede_social: redeSocialPessoaController.text,
          religiao_id: religiaoSelected.value,
          igreja_id: igrejaPessoaController.text,
          funcao_igreja: funcaoIgrejaPessoaController.text,
          status: 1,
          usuario_id: box.read('auth')['user']['id'],
          familia_id: family.id);

      final token = box.read('auth')['access_token'];

      final mensagem = await peopleRepository.insertPeople(
          "Bearer " + token, pessoa, File(photoUrlPath.value));

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

      familyController.getFamilies();
    } else {
      retorno = {
        "return": 1,
        "message": "Preencha todos os campos da família!"
      };
    }
    return retorno;
  }

  void removePeople(Pessoas pessoa) {
    composicaoFamiliar.remove(pessoa);
  }

  void clearPeopleModal() {
    peopleFormKey.currentState!.reset();
  }

  void getReligion() async {
    listReligion.clear();
    final token = box.read('auth')['access_token'];
    listReligion.value = await repositoryReligion.getALl("Bearer $token");
  }

  void getChurch() async {
    listChurch.clear();
    final token = box.read('auth')['access_token'];
    listChurch.value = await repositoryChurch.getALl("Bearer $token");

    suggestions.clear();

    for (var element in listChurch) {
      suggestions.add(element.descricao!);
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
    // Lista de todos os TextEditingController
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
      parentescoPessoaController,
      statusPessoaController,
      usuarioId,
      familiaId,
      igrejaPessoaController,
    ];

    // Itera sobre todos os TextEditingController e limpa cada um deles
    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
