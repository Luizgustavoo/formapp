import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyController extends GetxController {
  final box = GetStorage('credenciado');
  List<Family>? families;

  Family? selectedFamily;

  RxInt tabIndex = 0.obs;

  RxList<Family> listFamilies = <Family>[].obs;

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

  final repository = Get.find<FamilyRepository>();

  @override
  void onInit() {
    getFamilies();
    super.onInit();
  }

  void getFamilies() async {
    final token = box.read('auth')['access_token'];

    listFamilies.value = await repository.getALl("Bearer " + token);

    print(listFamilies.value);
  }
}
