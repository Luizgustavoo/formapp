import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/via_cep.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/utils/format_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyController extends GetxController
    with SingleGetTickerProviderMixin {
  TextEditingController idFamiliaController = TextEditingController();
  TextEditingController nomeFamiliaController = TextEditingController();
  TextEditingController cepFamiliaController = TextEditingController();
  TextEditingController ruaFamiliaController = TextEditingController();
  TextEditingController numeroCasaFamiliaController = TextEditingController();
  TextEditingController bairroFamiliaController = TextEditingController();
  TextEditingController cidadeFamiliaController = TextEditingController();
  TextEditingController ufFamiliaController = TextEditingController();
  TextEditingController complementoFamiliaController = TextEditingController();
  TextEditingController residenciaPropriaFamiliaController =
      TextEditingController();
  TextEditingController statusFamiliaController = TextEditingController();

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
  final TextEditingController searchController = TextEditingController();

  final box = GetStorage('credenciado');
  List<Family>? families;

  Family? selectedFamily;
  List<Pessoas>? listPessoas = [];

  RxList<Pessoas> composicaoFamiliar = <Pessoas>[].obs;

  RxInt tabIndex = 0.obs;

  RxList<Family> listFamilies = <Family>[].obs;

  TabController? tabController;

  final GlobalKey<FormState> familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> individualFormKey = GlobalKey<FormState>();

  RxInt estadoCivilSelected = 1.obs;
  RxInt religiaoSelected = 1.obs;

  RxString sexo = 'Masculino'.obs;
  RxString civil = 'Solteiro(a)'.obs;

  RxString parentesco = 'Avô(ó)'.obs;
  RxString religiao = 'Católica'.obs;
  RxBool residenceOwn = false.obs;
  RxBool provedorCheckboxValue = false.obs;
  RxBool familyInfo = true.obs;
  final formKey = GlobalKey<FormState>();

  final repository = Get.find<FamilyRepository>();

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      tabIndex.value = tabController!.index;
    });

    getFamilies();
    super.onInit();
  }

  void popularCampos() {
    idFamiliaController.text = selectedFamily!.id.toString();
    nomeFamiliaController.text = selectedFamily!.nome.toString();
    cepFamiliaController.text = selectedFamily!.cep.toString();
    ruaFamiliaController.text = selectedFamily!.endereco.toString();
    numeroCasaFamiliaController.text = selectedFamily!.numero_casa.toString();
    bairroFamiliaController.text = selectedFamily!.bairro.toString();
    cidadeFamiliaController.text = selectedFamily!.cidade.toString();
    ufFamiliaController.text = selectedFamily!.uf.toString();
    complementoFamiliaController.text = selectedFamily!.complemento.toString();
    residenciaPropriaFamiliaController.text =
        selectedFamily!.residencia_propria.toString();
    statusFamiliaController.text = selectedFamily!.status.toString();

    listPessoas = selectedFamily!.pessoas;
  }

  void addPessoa() {
    Pessoas pessoa = Pessoas(
      nome: nomePessoaController.text,
      cpf: cpfPessoaController.text,
    );

    composicaoFamiliar.add(pessoa);
  }

  void getFamilies() async {
    final token = box.read('auth')['access_token'];

    listFamilies.value = await repository.getALl("Bearer " + token);
  }

  /*PARTE RESPONSAVEL PELO CEP */
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
      limpaCEP();
    } else {
      ruaFamiliaController.text = addressData['logradouro'];
      bairroFamiliaController.text = addressData['bairro'];
      cidadeFamiliaController.text = addressData['localidade'];
      ufFamiliaController.text = addressData['uf'];
    }
  }
  /*FINAL PARTE RESPONSAVEL PELO CEP */

  /*PARTE RESPONSAVEL PELA FORMATACAO*/
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

  bool validateCPF() {
    return FormattersValidators.validateCPF(cpfPessoaController.text);
  }

  bool validatePhone() {
    return FormattersValidators.validatePhone(celularPessoaController.text);
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

  void limpaCEP() {
    ruaFamiliaController.text = '';
    cidadeFamiliaController.text = '';
    bairroFamiliaController.text = '';
    ufFamiliaController.text = '';
    complementoFamiliaController.text = '';
    numeroCasaFamiliaController.text = '';
  }
}
