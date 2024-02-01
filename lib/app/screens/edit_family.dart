import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/screens/edit_person.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

class EditFamily extends StatefulWidget {
  const EditFamily({super.key});

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> with TickerProviderStateMixin {
  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _individualFormKey = GlobalKey<FormState>();

  String sexo = 'Masculino';
  String civil = 'Solteiro(a)';
  String religiao = 'Católica';
  String provedor = 'Não';

  bool _residenceOwn = false;
  bool provedorCheckboxValue = false;
  bool familyInfo = true;
  final _formKey = GlobalKey<FormState>();

  int editedFamilyMemberIndex = -1;
  int tabIndex = 0;

  List<FamilyMember> familyMembersList = [];

  String photoUrl = '';

  FamilyMember familyMember = FamilyMember(
    nomeCompleto: '',
    sexo: '',
    cpf: '',
    dataNascimento: '',
    estadoCivil: '',
    tituloEleitor: '',
    zonaEleitoral: '',
    contato: '',
    redeSocial: '',
    religiao: '',
    trabalho: '',
    cargo: '',
    funcIgreja: '',
    igreja: '',
    provedor: '',
  );

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
  late TabController _tabController;

  void _excluirMembroFamilia(int index) {
    setState(() {
      familyMembersList.removeAt(index);
    });
  }

  void _editarMembroFamilia(int index) {
    setState(() {
      editedFamilyMemberIndex = index;

      FamilyMember editedMember = familyMembersList[index];

      nomeCompletoController.text = editedMember.nomeCompleto;
      dataNascimentoController.text = editedMember.dataNascimento;
      cpfController.text = editedMember.cpf;
      tituloEleitorController.text = editedMember.tituloEleitor;
      zonaEleitoralController.text = editedMember.zonaEleitoral;
      trabalhoController.text = editedMember.trabalho;
      cargoController.text = editedMember.cargo;
      contatoController.text = editedMember.contato;
      redeSocialController.text = editedMember.redeSocial;
      igrejaController.text = editedMember.igreja;
      funcIgrejaController.text = editedMember.funcIgreja;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    nomeCompletoController.dispose();
    dataNascimentoController.dispose();
    cpfController.dispose();
    tituloEleitorController.dispose();
    zonaEleitoralController.dispose();
    trabalhoController.dispose();
    cargoController.dispose();
    contatoController.dispose();
    redeSocialController.dispose();
    igrejaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tabIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle de Família'),
          bottom: TabBar(
            controller: _tabController,
            labelStyle: CustomTextStyle.button2(context),
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Família'),
              Tab(text: 'Composição Familiar'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFamilyForm(),
            _familyComposition(),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            elevation: 5,
            onPressed: () {
              if (tabIndex == 0) {
                print('Adicionar novo membro à Composição Familiar');
              } else if (tabIndex == 1) {
                print('Salvar informações da Família');
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green.shade800,
            child: const Icon(
              Icons.save_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyForm() {
    return Form(
      key: _familyFormKey,
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  key: GlobalKey(),
                  initiallyExpanded: familyInfo,
                  onExpansionChanged: (value) {
                    familyInfo = value;
                  },
                  title: const Text(
                    'Informações da Família',
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Divider(
                    height: 5,
                    thickness: 3,
                    color: Colors.orange.shade500,
                  ),
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome da Família',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o nome da família';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            splashRadius: 2,
                            iconSize: 20,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search_rounded,
                            )),
                        labelText: 'CEP',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o nome da rua';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Logradouro',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o nome da rua';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Complemento',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o nome da rua';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nº',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o número da rua';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o número da rua';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Cidade',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o nome da rua';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'UF',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o número da rua';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Residência Própria: ',
                          style: CustomTextStyle.form(context),
                        ),
                        Switch(
                          activeColor: Colors.orange.shade700,
                          inactiveThumbColor: Colors.orange.shade500,
                          inactiveTrackColor: Colors.orange.shade100,
                          value: _residenceOwn,
                          onChanged: (value) {
                            setState(() {
                              _residenceOwn = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _familyComposition() {
    return Form(
      key: _individualFormKey,
      child: Card(
        child: Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return CustomFamilyCard(
                  stripe: index % 2 == 0 ? true : false,
                  memberName: 'Luiz',
                  memberContact: '43 99928-9380',
                  editMember: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const EditPerson())));
                  },
                  messageMember: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: MessageModal(
                          showWidget: false,
                        ),
                      ),
                    );
                  },
                  supportMember: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: MessageModal(
                          showWidget: true,
                        ),
                      ),
                    );
                  },
                  deleteMember: () {});
            },
          ),
        ),
      ),
    );
  }
}
