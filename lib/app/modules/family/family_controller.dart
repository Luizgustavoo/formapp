import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/repository/family_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyController extends GetxController
    with SingleGetTickerProviderMixin {
  /// CONTROLLERS PARA DADOS DA FAMÍLIA
  TextEditingController idFamiliaController = TextEditingController();
  TextEditingController nomeFamiliaController = TextEditingController();
  TextEditingController cepFamiliaController = TextEditingController();
  TextEditingController enderecoFamiliaController = TextEditingController();
  TextEditingController numeroCasaFamiliaController = TextEditingController();
  TextEditingController bairroFamiliaController = TextEditingController();
  TextEditingController cidadeFamiliaController = TextEditingController();
  TextEditingController ufFamiliaController = TextEditingController();
  TextEditingController complementoFamiliaController = TextEditingController();
  TextEditingController residenciaPropriaFamiliaController =
      TextEditingController();
  TextEditingController statusFamiliaController = TextEditingController();

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
  TextEditingController funcaoIgrejaPessoaController = TextEditingController();
  TextEditingController parentescoPessoaController = TextEditingController();
  TextEditingController statusPessoaController = TextEditingController();
  TextEditingController usuarioId = TextEditingController();
  TextEditingController familiaId = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  /// fim CONTROLLERS PARA A PESSOA

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

  RxString sexo = 'Masculino'.obs;
  RxString civil = 'Solteiro(a)'.obs;
  RxString religiao = 'Católica'.obs;
  RxString photoUrl = ''.obs;
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

    print("onInit chamado");
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
    enderecoFamiliaController.text = selectedFamily!.endereco.toString();
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
    print('ADD PESSOAS');
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
}
