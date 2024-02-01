import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PeopleController extends GetxController {
  final box = GetStorage('credenciado');
  List<Family>? families;

  Family? selectedFamily;
  List<Pessoas>? listPessoas = [];

  RxInt tabIndex = 0.obs;

  RxList<Family> listFamilies = <Family>[].obs;

  /// CONTROLLERS PARA A PESSOA
  TextEditingController idPessoaController = TextEditingController();
  TextEditingController nomePessoaController = TextEditingController();
  TextEditingController nascimentoPessoaController = TextEditingController();
  TextEditingController enderecoPessoaController = TextEditingController();
  TextEditingController bairroPessoaController = TextEditingController();
  TextEditingController cepPessoaController = TextEditingController();
  TextEditingController cpfPessoaController = TextEditingController();
  TextEditingController rgPessoaController = TextEditingController();
  TextEditingController orgaoEmissorRgPessoaController =
      TextEditingController();
  TextEditingController ufOrgaoEmissorRgPessoaController =
      TextEditingController();
  TextEditingController telFixoPessoaController = TextEditingController();
  TextEditingController celularPessoaController = TextEditingController();
  TextEditingController escolaridadeController = TextEditingController();
  TextEditingController naturalidadeController = TextEditingController();
  TextEditingController estadoCivilPessoaController = TextEditingController();
  TextEditingController sexoPessoaController = TextEditingController();
  TextEditingController referenciaCasaPessoaController =
      TextEditingController();
  TextEditingController dataCadastroPessoaController = TextEditingController();
  TextEditingController usuarioCadastrouController = TextEditingController();
  TextEditingController emailPessoaController = TextEditingController();
  TextEditingController statusPessoaController = TextEditingController();
  TextEditingController numeroEnderecoPessoaController =
      TextEditingController();
  TextEditingController telefoneRecadoPessoaController =
      TextEditingController();
  TextEditingController dataUltimaAtualizacaoController =
      TextEditingController();
  TextEditingController usuarioAlterouController = TextEditingController();
  TextEditingController trabalhaController = TextEditingController();
  TextEditingController complementoController = TextEditingController();

  /// fim CONTROLLERS PARA A PESSOA
  ///
  ///

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

  void popularCampos() {}

  void getFamilies() async {
    final token = box.read('auth')['access_token'];

    listFamilies.value = await repository.getALl("Bearer " + token);
  }
}
