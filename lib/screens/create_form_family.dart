import 'package:flutter/material.dart';
import 'package:formapp/widgets/custom_text_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyRegistrationScreen(),
    );
  }
}

class MyRegistrationScreen extends StatefulWidget {
  const MyRegistrationScreen({super.key});

  @override
  _MyRegistrationScreenState createState() => _MyRegistrationScreenState();
}

class _MyRegistrationScreenState extends State<MyRegistrationScreen> {
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

  // Dados Individuais
  String individualName = '';
  // Adicione os demais campos individuais aqui conforme necessário

  String selectedSexo = 'Masculino';
  bool _residenceOwn = false;
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
    return Form(
      key: _individualFormKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ElevatedButton(
            onPressed: () {
              _openIndividualModal();
            },
            child: const Text('Preencher Informações Adicionais'),
          ),
        ],
      ),
    );
  }

  // Método para abrir o modal de informações individuais
  void _openIndividualModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: SingleChildScrollView(
              child: Container(
                // color: Colors.redAccent,
                // height: MediaQuery.of(context).size.height * 0.5,
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          backgroundBlendMode: BlendMode
                              .multiply, // Ajuste o blend mode conforme necessário
                          color: Colors.grey[
                              300], // Ajuste a cor de fundo conforme necessário
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            // Adicione a lógica para carregar a foto aqui
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nome Completo'),
                      onChanged: (value) {
                        individualName = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Contato'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Rede Social'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedSexo,
                      onChanged: (value) {
                        setState(() {
                          selectedSexo = value!;
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
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Data de Nascimento'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Título de Eleitor'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para salvar as informações do modal
                          Navigator.of(context).pop();
                        },
                        child: const Text('Salvar Informações'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Adicione métodos para salvar os dados conforme necessário
}
