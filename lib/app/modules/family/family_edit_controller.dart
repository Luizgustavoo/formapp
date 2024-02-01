import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyEditController extends GetxController {
  final box = GetStorage('credenciado');

  RxInt tabIndex = 0.obs;

  RxString nomeDaFamilia = "".obs;

  TextEditingController nomeFamiliaController = TextEditingController();

  TextEditingController nomeCompletoController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController tituloEleitorController = TextEditingController();
  TextEditingController zonaEleitoralController = TextEditingController();
  TextEditingController trabalhoController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController contatoController = TextEditingController();
  TextEditingController redeSocialController = TextEditingController();
  TextEditingController igrejaController = TextEditingController();
  TextEditingController funcIgrejaController = TextEditingController();
  TabController? tabController;

  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> individualFormKey = GlobalKey<FormState>();

  RxString sexo = 'Masculino'.obs;
  RxString civil = 'Solteiro(a)'.obs;
  RxString religiao = 'Católica'.obs;
  RxString provedor = 'Não'.obs;

  RxBool residenceOwn = false.obs;
  RxBool provedorCheckboxValue = false.obs;
  RxBool familyInfo = true.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    nomeFamiliaController.text = "teste";
    print(nomeDaFamilia.value);
    super.onInit();
  }
}
