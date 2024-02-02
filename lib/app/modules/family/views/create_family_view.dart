import 'package:flutter/material.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class CreateFamilyView extends GetView<FamilyController> {
  const CreateFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: controller.tabIndex.value,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Controle de Família'),
            bottom: TabBar(
              controller: controller.tabController,
              labelStyle: CustomTextStyle.button2(context),
              labelColor: Colors.white,
              tabs: const [
                Tab(text: 'Família'),
                Tab(text: 'Composição Familiar'),
              ],
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
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
                  if (controller.tabController!.index == 0) {
                    print('Adicionar novo membro à Composição Familiar');
                  } else if (controller.tabController!.index == 1) {
                    print('Salvar informações da Família');
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: controller.tabController!.index == 1
                    ? Colors.green.shade800
                    : Colors.orange.shade700,
                child: Icon(
                  controller.tabController!.index == 1
                      ? Icons.save_outlined
                      : Icons.add,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildFamilyForm() {
    return Form(
      key: controller.familyFormKey,
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                key: GlobalKey(),
                initiallyExpanded: controller.familyInfo.value,
                onExpansionChanged: (value) {
                  controller.familyInfo.value = value;
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
                      const Text(
                        'Residência Própria: ',
                        style: TextStyle(),
                      ),
                      Switch(
                        activeColor: Colors.orange.shade700,
                        inactiveThumbColor: Colors.orange.shade500,
                        inactiveTrackColor: Colors.orange.shade100,
                        value: controller.residenceOwn.value,
                        onChanged: (value) {
                          controller.residenceOwn.value = value;
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
                        backgroundImage: controller.photoUrl.value.isNotEmpty
                            ? NetworkImage(controller.photoUrl.value)
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
                      const Text(
                        'Provedor da casa: ',
                        style: TextStyle(),
                      ),
                      Switch(
                        activeColor: Colors.orange.shade700,
                        inactiveThumbColor: Colors.orange.shade500,
                        inactiveTrackColor: Colors.orange.shade100,
                        value: controller.provedorCheckboxValue.value,
                        onChanged: (value) {
                          controller.provedorCheckboxValue.value = value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: controller.nomePessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome Completo'),
                    onChanged: (value) {},
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
                          value: controller.sexo.value,
                          onChanged: (value) {},
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: controller.civil.value,
                          onChanged: (value) {},
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
                    controller: controller.nascimentoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Data de Nascimento'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.cpfPessoaController,
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
                          controller:
                              controller.tituloEleitoralPessoaController,
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
                          controller: controller.zonaEleitoralPessoaController,
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
                    controller: controller.localTrabalhoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Trabalho'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.cargoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Cargo'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.celularPessoaController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Telefone'),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: controller.redeSocialPessoaController,
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
                    value: controller.religiao.value,
                    onChanged: (value) {
                      controller.religiao.value = value!;
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
                        border: OutlineInputBorder(), labelText: 'Igreja'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.funcaoIgrejaPessoaController,
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
        ],
      ),
    );
  }

  Widget _familyComposition() {
    return Form(
      key: controller.individualFormKey,
      child: ListView(
        children: [
          Card(
            child: ExpansionTile(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              initiallyExpanded: true,
              title: const Text('Composição Familiar'),
              children: controller.listFamilies.map((member) {
                return Card(
                  color: Colors.orange.shade200,
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_rounded)),
                    title: Text('Nome Completo: ${member.nome}'),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
