import 'package:flutter/material.dart';
import 'package:formapp/models/family_member.dart';
import 'package:formapp/widgets/custom_text_style.dart';

class TestForm extends StatefulWidget {
  const TestForm({super.key});

  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _individualFormKey = GlobalKey<FormState>();

  // Dados da Família
  String familyName = '';
  String cep = '';
  String neighborhood = '';
  String street = '';
  String number = '';
  String city = '';
  String uf = '';

  int _currentStep = 0;

  // Dados Individuais
  // Dados do formulário
  String nomeCompleto = '';
  String sexo = 'Masculino';
  String cpf = '';
  String dataNascimento = '';
  String estadoCivil = '';
  String tituloEleitor = '';
  String zonaEleitoral = '';
  String contato = '';
  String civil = 'Solteiro(a)';
  String redeSocial = '';
  String religiao = 'Católica';

  // Adicione os demais campos individuais aqui conforme necessário

  String selectedSexo = 'Masculino';
  bool _residenceOwn = false;
  bool provedorCheckboxValue = false;
  final _formKey = GlobalKey<FormState>();

  // Variável para armazenar a foto
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
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Família'),
          bottom: TabBar(
            labelStyle: CustomTextStyle.button2(context),
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
                        TextButton(
                          onPressed: () {
                            if (_currentStep > 0) {
                              setState(() {
                                _currentStep -= 1;
                              });
                            }
                          },
                          child: Text(
                            'ANTERIOR',
                            style: CustomTextStyle.button2(context),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange.shade500,
                          ),
                          onPressed: () {
                            if (_currentStep < 3) {
                              setState(() {
                                _currentStep += 1;
                              });
                            } else {
                              // Chamar o método para salvar os dados
                              _salvarDados();
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
                      ],
                    );
                  },
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  steps: getSteppers())),
          Card(
            child: ExpansionTile(
              title: const Text('Informações do Morador'),
              children: [
                ListTile(
                  title: Text('Nome Completo: ${familyMember.nomeCompleto}'),
                ),
                ListTile(
                  title: Text('Sexo: ${familyMember.tituloEleitor}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _salvarDados() {
    // Salvar informações da família
    if (_familyFormKey.currentState!.validate()) {
      // Atualizar as informações do morador com os dados do formulário
      familyMember = familyMember.copyWith(
        nomeCompleto: nomeCompleto,
        sexo: sexo,
        cpf: cpf,
        dataNascimento: dataNascimento,
        estadoCivil: estadoCivil,
        tituloEleitor: tituloEleitor,
        zonaEleitoral: zonaEleitoral,
        contato: contato,
        redeSocial: redeSocial,
        religiao: religiao,
      );

      // Exemplo de impressão no console (substitua pelo código de salvamento real)
      print('Informações da família salvas:');
      print('Nome da Família: $familyName');
      print('Informações do morador salvas:');
      print(familyMember.toMap());
    }
  }

  List<Step> getSteppers() => [
        Step(
          title: const Text(''),
          content: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/images/default_avatar.jpg')
                        as ImageProvider,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    backgroundBlendMode: BlendMode
                        .multiply, // Ajuste o blend mode conforme necessário
                    color: Colors
                        .grey[300], // Ajuste a cor de fundo conforme necessário
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // Adicione a lógica para carregar a foto aqui
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome Completo'),
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
                  ),
                  const SizedBox(width: 0),
                  Expanded(
                    flex: 3,
                    child: CheckboxListTile(
                      activeColor: Colors.orange.shade500,
                      title: Text(
                        'PROVEDOR?',
                        style: CustomTextStyle.button2(context),
                      ),
                      value: provedorCheckboxValue,
                      onChanged: (value) {
                        setState(() {
                          provedorCheckboxValue = value!;
                        });
                      },
                    ),
                  ),
                ],
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
              const SizedBox(height: 10)
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
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Trabalho'),
              onChanged: (value) {
                familyMember.trabalho = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Cargo'),
              onChanged: (value) {
                familyMember.cargo = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Telefone'),
              onChanged: (value) {
                familyMember.contato = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
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
  // Adicione métodos para salvar os dados conforme necessário
}
