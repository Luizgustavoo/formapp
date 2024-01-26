import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

class EditPerson extends StatefulWidget {
  const EditPerson({super.key});

  @override
  State<EditPerson> createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  String sexo = 'Masculino';
  String civil = 'Solteiro(a)';
  String religiao = 'Católica';
  String provedor = 'Não';
  // final bool _residenceOwn = false;
  bool provedorCheckboxValue = false;
  bool familyInfo = true;
  String photoUrl = '';

  final GlobalKey<FormState> _familyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALTERAR FAMILIAR'),
      ),
      body: Form(
        key: _familyFormKey,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: nomeCompletoController,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: sexo,
                              onChanged: (value) {
                                setState(() {
                                  familyMember.sexo = value!;
                                });
                              },
                              items: [
                                'Masculino',
                                'Feminino'
                              ].map<DropdownMenuItem<String>>((String value) {
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Título de Eleitor'),
                              onChanged: (value) {
                                familyMember.tituloEleitor = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Zona Eleitoral'),
                              onChanged: (value) {
                                familyMember.zonaEleitoral = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: trabalhoController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Trabalho'),
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: contatoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Telefone'),
                              onChanged: (value) {
                                familyMember.contato = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: redeSocialController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Rede Social'),
                              onChanged: (value) {
                                familyMember.redeSocial = value;
                              },
                            ),
                          ),
                        ],
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
                            border: OutlineInputBorder(),
                            labelText: 'Religião'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: igrejaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Igreja'),
                        onChanged: (value) {
                          familyMember.igreja = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: funcIgrejaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Função/Igreja'),
                        onChanged: (value) {
                          familyMember.funcIgreja = value;
                        },
                      ),
                      const SizedBox(height: 10)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 5,
          onPressed: () {},
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
    );
  }
}
