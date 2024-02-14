import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/via_cep.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:formapp/app/utils/format_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class FamilyController extends GetxController
    with SingleGetTickerProviderMixin {
  TextEditingController searchController = TextEditingController();
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
  TextEditingController igrejaPessoaController = TextEditingController();

  final box = GetStorage('credenciado');
  Family? selectedFamily;

  var photoUrlPath = ''.obs;
  var isImagePicPathSet = false.obs;
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
  RxString parentesco = 'Avô(ó)'.obs;
  RxBool residenceOwn = false.obs;
  RxBool provedorCheckboxValue = false.obs;
  RxBool familyInfo = true.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.find<FamilyRepository>();
  Animation<double>? animation;
  AnimationController? animationController;

  final uploadList = <MultipartFile>[];

  List<Map<String, FileImage>>? imageFileList = [];

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

  @override
  void onClose() {
    getFamilies();
    super.onClose();
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

  void searchFamily(String query) {
    if (query.isEmpty) {
      getFamilies();
    } else {
      listFamilies.assignAll(listFamilies
          .where((family) =>
              family.nome!.toLowerCase().contains(query.toLowerCase()) ||
              family.pessoas![0].provedor_casa!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList());
    }
  }

  void fillInFields() {
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

  void addPessoa(BuildContext context) {
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
    );

    bool pessoaExistente = composicaoFamiliar.any((p) =>
        p.nome == pessoa.nome && p.data_nascimento == pessoa.data_nascimento);

    if (!pessoaExistente) {
      // Se a pessoa não existir, adicione-a à composição
      composicaoFamiliar.add(pessoa);
      Get.back();
    } else {
      Get.snackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 1300),
        'Falha',
        'Pessoa já adicionada!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Trate o caso em que a pessoa já existe na composição, por exemplo, exibindo uma mensagem para o usuário.
    }

    // composicaoFamiliar.add(pessoa);
    // clearPeopleModal();

    // final nome = nomePessoaController.text.replaceAll(' ', '').toLowerCase();
    // final dataNascimento = nascimentoPessoaController.text.replaceAll('/', '');

    // Map<String, FileImage> imagem = {
    //   "${nome}_$dataNascimento": FileImage(File(photoUrlPath.value))
    // };

    // imageFileList!.add(imagem);

    print(imageFileList);
  }

  Future<String> saveFamily() async {
    String retorno = "";
    if (familyFormKey.currentState!.validate()) {
      if (composicaoFamiliar.isEmpty) {
        retorno = "Insira pelo menos um morador na casa!";
      } else {
        Family family = Family(
          nome: nomeFamiliaController.text,
          cep: cepFamiliaController.text,
          endereco: ruaFamiliaController.text,
          complemento: complementoFamiliaController.text,
          bairro: bairroFamiliaController.text,
          numero_casa: numeroCasaFamiliaController.text,
          cidade: cidadeFamiliaController.text,
          uf: ufFamiliaController.text,
          residencia_propria: residenceOwn.value ? 'sim' : 'nao',
          status: 1,
          pessoas: composicaoFamiliar,
          usuario_id: box.read('auth')['user']['id'],
        );

        final token = box.read('auth')['access_token'];

        await repository.insert("Bearer " + token, family);
        retorno = 'Família salva com sucesso!'; // Adicione este log
        getFamilies();
      }
    } else {
      retorno = "Preencha todos os campos da família!";
    }
    return retorno;
  }

  void removePeople(Pessoas pessoa) {
    composicaoFamiliar.remove(pessoa);
  }

  void clearPeopleModal() {
    formKey.currentState!.reset();
  }

  void getFamilies() async {
    final token = box.read('auth')['access_token'];
    listFamilies.value = await repository.getAll("Bearer " + token);
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
      clearCEP();
    } else {
      ruaFamiliaController.text = addressData['logradouro'];
      bairroFamiliaController.text = addressData['bairro'];
      cidadeFamiliaController.text = addressData['localidade'];
      ufFamiliaController.text = addressData['uf'];
    }
  }

  void clearCEP() {
    ruaFamiliaController.text = '';
    cidadeFamiliaController.text = '';
    bairroFamiliaController.text = '';
    ufFamiliaController.text = '';
    complementoFamiliaController.text = '';
    numeroCasaFamiliaController.text = '';
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
