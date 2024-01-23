import 'package:flutter/material.dart';
import 'package:formapp/models/family_member.dart';
import 'package:formapp/utils/custom_text_style.dart';

class CreateFamily extends StatefulWidget {
  const CreateFamily({super.key});

  @override
  State<CreateFamily> createState() => _CreateFamilyState();
}

class _CreateFamilyState extends State<CreateFamily> {
  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _individualFormKey = GlobalKey<FormState>();

  int _currentStep = 0;

  String sexo = 'Masculino';
  String civil = 'Solteiro(a)';
  String religiao = 'Católica';
  String provedor = 'Não';

  bool _residenceOwn = false;
  bool provedorCheckboxValue = false;
  final _formKey = GlobalKey<FormState>();

  int editedFamilyMemberIndex = -1;

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

      _currentStep = 0;
    });
  }

  @override
  void dispose() {
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Família'),
          bottom: TabBar(
            labelStyle: CustomTextStyle.button2(context),
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Família'),
              Tab(text: 'Composição Familiar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFamilyForm(),
            _buildIndividualForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyForm() {
    return Form(
      key: _familyFormKey,
      child: ListView(
        padding: const EdgeInsets.all(2.0),
        children: [
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(8),
            elevation: 2,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 15.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Informações da Família',
                      style: CustomTextStyle.subtitleNegrit(context),
                    ),
                    const SizedBox(height: 15),
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
                        labelText: 'Bairro',
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
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Complemento',
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
                              labelText: 'Rua',
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
                        Checkbox(
                          value: _residenceOwn,
                          onChanged: (value) {
                            setState(() {
                              _residenceOwn = value ?? false;
                            });
                          },
                        ),
                        const Text('Residência própria'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividualForm() {
    return Form(
      key: _individualFormKey,
      child: ListView(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Colors.grey.withOpacity(0.30),
              padding: const EdgeInsets.all(8.0),
              child: Stepper(
                  elevation: 5,
                  controlsBuilder: (context, details) {
                    return Row(
                      children: [
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                            ),
                            onPressed: () {
                              if (_currentStep > 0) {
                                setState(() {
                                  _currentStep -= 1;
                                });
                              }
                            },
                            child: _currentStep <= 0
                                ? Text(
                                    '',
                                    style: CustomTextStyle.button2(context),
                                  )
                                : Text(
                                    'ANTERIOR',
                                    style: CustomTextStyle.button2(context),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              backgroundColor: Colors.orange.shade500,
                            ),
                            onPressed: () {
                              if (_currentStep < 3) {
                                setState(() {
                                  _currentStep += 1;
                                });
                              } else if (_individualFormKey.currentState!
                                  .validate()) {
                                setState(() {
                                  familyMembersList.add(familyMember);

                                  _individualFormKey.currentState!.reset();
                                });
                              }
                            },
                            child: _currentStep >= 3
                                ? Text(
                                    'ADICIONAR',
                                    style: CustomTextStyle.button(context),
                                  )
                                : Text(
                                    "PRÓXIMO",
                                    style: CustomTextStyle.button(context),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  steps: getSteppers())),
          Card(
            child: ExpansionTile(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              initiallyExpanded: true,
              title: const Text('Composição Familiar'),
              children: familyMembersList.map((member) {
                return Card(
                  color: Colors.orange.shade200,
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          editedFamilyMemberIndex =
                              familyMembersList.indexOf(member);
                          nomeCompletoController.text = member.nomeCompleto;
                          dataNascimentoController.text = member.dataNascimento;
                          cpfController.text = member.cpf;
                          tituloEleitorController.text = member.tituloEleitor;
                          zonaEleitoralController.text = member.zonaEleitoral;
                          trabalhoController.text = member.trabalho;
                          cargoController.text = member.cargo;
                          contatoController.text = member.contato;
                          redeSocialController.text = member.redeSocial;
                          igrejaController.text = member.igreja;
                          funcIgrejaController.text = member.funcIgreja;
                          _currentStep = 0;
                        });
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_rounded)),
                    title: Text('Nome Completo: ${member.nomeCompleto}'),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteppers() => [
        Step(
          title: const Text(''),
          content: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
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
                  ),
                  Row(
                    children: [
                      Text(
                        'Provedor da casa: ',
                        style: CustomTextStyle.form(context),
                      ),
                      Switch(
                        activeColor: Colors.green.shade700,
                        inactiveThumbColor: Colors.orange.shade500,
                        inactiveTrackColor: Colors.orange.shade100,
                        value: provedorCheckboxValue,
                        onChanged: (value) {
                          setState(() {
                            provedorCheckboxValue = value;
                            familyMember.provedor =
                                provedorCheckboxValue ? 'Sim' : 'Não';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: nomeCompletoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Nome Completo'),
                onChanged: (value) {
                  setState(() {
                    familyMember.nomeCompleto = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome da rua';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: sexo,
                onChanged: (value) {
                  setState(() {
                    familyMember.sexo = value!;
                  });
                },
                items: ['Masculino', 'Feminino']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Sexo'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: civil,
                onChanged: (value) {
                  setState(() {
                    familyMember.estadoCivil = value!;
                  });
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
                    border: OutlineInputBorder(), labelText: 'Estado Civil'),
              ),
              const SizedBox(height: 10),
            ],
          ),
          state: _currentStep == 0 ? StepState.editing : StepState.complete,
          isActive: _currentStep == 0,
        ),
        Step(
          title: const Text(''),
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data de Nascimento'),
                onChanged: (value) {
                  familyMember.dataNascimento = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'CPF'),
                onChanged: (value) {
                  familyMember.cpf = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título de Eleitor'),
                onChanged: (value) {
                  familyMember.tituloEleitor = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Zona Eleitoral'),
                onChanged: (value) {
                  familyMember.zonaEleitoral = value;
                },
              ),
              const SizedBox(height: 10)
            ],
          ),
          state: _currentStep == 1 ? StepState.editing : StepState.complete,
          isActive: _currentStep == 1,
        ),
        Step(
          title: const Text(''),
          content: Column(children: [
            TextFormField(
              controller: trabalhoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Trabalho'),
              onChanged: (value) {
                familyMember.trabalho = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: cargoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Cargo'),
              onChanged: (value) {
                familyMember.cargo = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: contatoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Telefone'),
              onChanged: (value) {
                familyMember.contato = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: redeSocialController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Rede Social'),
              onChanged: (value) {
                familyMember.redeSocial = value;
              },
            ),
            const SizedBox(height: 10),
          ]),
          state: _currentStep == 2 ? StepState.editing : StepState.complete,
          isActive: _currentStep == 2,
        ),
        Step(
          title: const Text(''),
          content: Column(children: [
            TextFormField(
              controller: igrejaController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Igreja'),
              onChanged: (value) {
                familyMember.igreja = value;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: religiao,
              onChanged: (value) {
                setState(() {
                  familyMember.religiao = value!;
                });
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
              controller: funcIgrejaController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Função/Igreja'),
              onChanged: (value) {
                familyMember.funcIgreja = value;
              },
            ),
            const SizedBox(height: 10)
          ]),
          state: _currentStep == 3 ? StepState.editing : StepState.complete,
          isActive: _currentStep == 3,
        ),
      ];
}
