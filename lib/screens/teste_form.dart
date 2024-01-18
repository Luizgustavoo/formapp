import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Família'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Família'),
              Tab(text: 'Indivíduo'),
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
    return ListView(
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
                            // Finalizar o formulário, salvar dados, etc.
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
      ],
    );
  }

  List<Step> getSteppers() => [
        Step(
          title: const Text(''),
          content: Column(
            children: [
              CircleAvatar(
                radius: 30,
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
                        labelText: 'Nome Completo',
                      ),
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
                    sexo = value!;
                  });
                },
                items: ['Masculino', 'Feminino']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Sexo'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: civil,
                onChanged: (value) {
                  setState(() {
                    sexo = value!;
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
                decoration: const InputDecoration(labelText: 'Estado Civil'),
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
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
                onChanged: (value) {
                  tituloEleitor = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CPF'),
                onChanged: (value) {
                  tituloEleitor = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Título de Eleitor'),
                onChanged: (value) {
                  tituloEleitor = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Zona Eleitoral'),
                onChanged: (value) {
                  zonaEleitoral = value;
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
              decoration: const InputDecoration(labelText: 'Trabalho'),
              onChanged: (value) {
                contato = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Cargo'),
              onChanged: (value) {
                redeSocial = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Telefone'),
              onChanged: (value) {
                redeSocial = value;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Rede Social'),
              onChanged: (value) {
                redeSocial = value;
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
              decoration: const InputDecoration(labelText: 'Igreja'),
              onChanged: (value) {
                contato = value;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: religiao,
              onChanged: (value) {
                setState(() {
                  religiao = value!;
                });
              },
              items: ['Católica', 'Evangélica', 'Outra']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Religião'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Função/Igreja'),
              onChanged: (value) {
                redeSocial = value;
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
