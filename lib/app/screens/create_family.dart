import 'package:flutter/material.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

class CreateFamily extends StatefulWidget {
  const CreateFamily({super.key});

  @override
  State<CreateFamily> createState() => _CreateFamilyState();
}

class _CreateFamilyState extends State<CreateFamily>
    with TickerProviderStateMixin {
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

  String photoUrl = '';

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
    setState(() {});
  }

  void _editarMembroFamilia(int index) {
    setState(() {
      editedFamilyMemberIndex = index;
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
              backgroundColor: tabIndex == 1
                  ? Colors.green.shade800
                  : Colors.orange.shade700,
              child: Icon(
                tabIndex == 1 ? Icons.save_outlined : Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ));
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

                //-------------->INFORMAÇÕES DO FAMILIAR<-------------------
                ExpansionTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  initiallyExpanded: true,
                  title: const Text(
                    'Informações do Familiar',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage(
                                      'assets/images/default_avatar.jpg')
                                  as ImageProvider,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              backgroundBlendMode: BlendMode.multiply,
                              color: Colors.grey[300],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Provedor da casa: ',
                          style: CustomTextStyle.form(context),
                        ),
                        Switch(
                          activeColor: Colors.orange.shade700,
                          inactiveThumbColor: Colors.orange.shade500,
                          inactiveTrackColor: Colors.orange.shade100,
                          value: provedorCheckboxValue,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: nomeCompletoController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome Completo'),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o nome da rua';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: sexo,
                            onChanged: (value) {
                              setState(() {});
                            },
                            items: ['Masculino', 'Feminino']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Sexo'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: civil,
                            onChanged: (value) {
                              setState(() {});
                            },
                            items: [
                              'Solteiro(a)',
                              'Casado(a)',
                              'Divorciado(a)',
                              'Emancipado(a)'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Estado Civil'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Data de Nascimento'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'CPF'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Título de Eleitor'),
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Zona Eleitoral'),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: trabalhoController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Trabalho'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: cargoController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Cargo'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: contatoController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Telefone'),
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: redeSocialController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Rede Social'),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: religiao,
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: ['Católica', 'Evangélica', 'Outra']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Religião'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: igrejaController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Igreja'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: funcIgrejaController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Função/Igreja'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10)
                  ],
                )
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
      child: ListView(children: [
        Card(
            child: ExpansionTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                initiallyExpanded: true,
                title: const Text('Composição Familiar'),
                children: [
              Card(
                color: Colors.orange.shade200,
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded),
                  ),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.delete_rounded)),
                  title: const Text('Nome Completo:'),
                ),
              ),
            ]))
      ]),
    );
  }
}
