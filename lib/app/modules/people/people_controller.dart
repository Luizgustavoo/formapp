import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/church_model.dart';
import 'package:formapp/app/data/models/estado_civil_model.dart';
import 'package:formapp/app/data/models/religion_model.dart';
import 'package:formapp/app/data/repository/church_repository.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/data/repository/religion_repository.dart';
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
  TextEditingController igrejaPessoaController = TextEditingController();
  TextEditingController funcaoIgrejaPessoaController = TextEditingController();
  TextEditingController parentescoPessoaController = TextEditingController();
  TextEditingController statusPessoaController = TextEditingController();
  TextEditingController usuarioId = TextEditingController();
  TextEditingController familiaId = TextEditingController();

  final GlobalKey<FormState> peopleFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  var photoUrlPath = ''.obs;
  var isImagePicPathSet = false.obs;
  RxBool provedorCheckboxValue = false.obs;
  RxString? sexo = 'Masculino'.obs;
  RxInt estadoCivilSelected = 1.obs;
  RxInt religiaoSelected = 1.obs;
  final repository = Get.find<MaritalStatusRepository>();
  final repositoryReligion = Get.find<ReligionRepository>();
  final repositoryChurch = Get.find<ChurchRepository>();
  final box = GetStorage('credenciado');
  RxList<EstadoCivil> listMaritalStatus = <EstadoCivil>[].obs;
  RxList<Religiao> listReligion = <Religiao>[].obs;
  RxList<Igreja> listChurch = <Igreja>[].obs;
  int suggestionsCount = 12;
  final focus = FocusNode();
  List<String> suggestions = [];

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
}
