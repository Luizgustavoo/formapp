import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/estado_civil_model.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditPeopleController extends GetxController {
  /// CONTROLLERS PARA A PESSOA
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

  RxString photoUrl = ''.obs;

  RxBool provedorCheckboxValue = false.obs;

  RxString? sexo = 'Masculino'.obs;

  RxString civil = 'Solteiro(a)'.obs;
  RxString religiao = 'Católica'.obs;

  final repository = Get.find<MaritalStatusRepository>();
  final box = GetStorage('credenciado');

  RxList<EstadoCivil> listMaritalStatus = <EstadoCivil>[].obs;

  @override
  void onInit() {
    getMaritalStatus();
    super.onInit();
  }

  void getMaritalStatus() async {
    final token = box.read('auth')['access_token'];

    listMaritalStatus.value = await repository.getALl("Bearer " + token);
  }
}
