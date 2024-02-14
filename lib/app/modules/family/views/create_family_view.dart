import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/custom_bottomsheet_file.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/family/views/add_people_family_view.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class CreateFamilyView extends GetView<FamilyController> {
  CreateFamilyView({super.key});

  final PeopleController peopleController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Controle de Família'),
        ),
        body: _buildFamilyForm(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionBubble(
            // Menu items
            items: [
              // Floating action menu item
              Bubble(
                title: "Morador",
                iconColor: Colors.white,
                bubbleColor: Colors.orange.shade500,
                icon: Icons.add_rounded,
                titleStyle: const TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'Poppinss'),
                onPress: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AddPeopleFamily(
                          controller: controller,
                          peopleController: peopleController),
                    ),
                  );

                  controller.animationController!.reverse();
                },
              ),
              // Floating action menu item
              Bubble(
                title: "Salvar",
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.save_rounded,
                titleStyle: const TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'Poppinss'),
                onPress: () async {
                  final retorno = await controller.saveFamily();
                  Get.defaultDialog(
                    title: "Atenção",
                    content: Text(retorno),
                  );
                  controller.animationController!.reverse();
                  Get.back();
                },
              ),
            ],

            // animation controller
            animation: controller.animation!,

            // On pressed change animation state
            onPress: () => controller.animationController!.isCompleted
                ? controller.animationController!.reverse()
                : controller.animationController!.forward(),

            // Floating Action button Icon color
            iconColor: Colors.white,

            // Flaoting Action button Icon
            iconData: Icons.menu_rounded,
            backGroundColor: Colors.orange.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyForm() {
    return Form(
      key: controller.familyFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
                  controller: controller.nomeFamiliaController,
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
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      controller.searchCEP();
                    }
                  },
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller.cepFamiliaController,
                    onChanged: (value) => controller.onCEPChanged(value),
                    maxLength: 9,
                    decoration: InputDecoration(
                      counterText: '',
                      suffixIcon: IconButton(
                          splashRadius: 2,
                          iconSize: 20,
                          onPressed: () {
                            controller.searchCEP();
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                          )),
                      labelText: 'CEP',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (!controller.validateCEP()) {
                        return 'CEP inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.ruaFamiliaController,
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
                        controller: controller.complementoFamiliaController,
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(),
                        ),
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
                            return 'Por favor, digite o número da casa';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.bairroFamiliaController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o número do bairro';
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
                        controller: controller.cidadeFamiliaController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da cidade';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: controller.ufFamiliaController,
                        decoration: const InputDecoration(
                          labelText: 'UF',
                          border: OutlineInputBorder(),
                        ),
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
                    Obx(() => Switch(
                          activeColor: Colors.orange.shade700,
                          inactiveThumbColor: Colors.orange.shade500,
                          inactiveTrackColor: Colors.orange.shade100,
                          value: controller.residenceOwn.value,
                          onChanged: (value) {
                            controller.residenceOwn.value = value;
                          },
                        )),
                  ],
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Composição Familiar',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Divider(
                height: 5,
                thickness: 3,
                color: Colors.orange.shade500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: Get.width * .5,
              height: controller.familyInfo.value
                  ? Get.height * .5
                  : Get.height * .7,
              child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.composicaoFamiliar.length,
                  itemBuilder: (context, index) {
                    Pessoas pessoa = controller.composicaoFamiliar[index];
                    return ExpansionTile(
                      leading: CircleAvatar(
                        radius: 20,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            height: 200,
                            'https://s2-techtudo.glbimg.com/L9wb1xt7tjjL-Ocvos-Ju0tVmfc=/0x0:1200x800/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_08fbf48bc0524877943fe86e43087e7a/internal_photos/bs/2023/q/l/TIdfl2SA6J16XZAy56Mw/canvaai.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        controller.composicaoFamiliar[index].nome!,
                        style: CustomTextStyle.subtitleNegrit(context),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomPersonCard(pessoa: pessoa),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20, color: Colors.blue),
                                    onPressed: () {
                                      // Lógica para editar
                                    },
                                    label: const Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.delete_outline_sharp,
                                        size: 20, color: Colors.red),
                                    onPressed: () {
                                      // Lógica para apagar
                                      controller.removePeople(pessoa);
                                    },
                                    label: const Text(
                                      'Apagar',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}

class AddPeopleFamily extends StatelessWidget {
  const AddPeopleFamily({
    super.key,
    required this.controller,
    required this.peopleController,
  });

  final FamilyController controller;
  final PeopleController peopleController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adicionar Pessoa',
                    style: CustomTextStyle.title(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Divider(
                      height: 5,
                      thickness: 3,
                      color: Colors.orange.shade500,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 35,
                            backgroundImage: controller.isImagePicPathSet ==
                                    true
                                ? FileImage(File(controller.photoUrlPath.value))
                                    as ImageProvider
                                : const AssetImage(
                                    'assets/images/default_avatar.jpg'),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                backgroundBlendMode: BlendMode.multiply,
                                color: Colors.grey[300],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          CustomBottomSheet());
                                },
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Provedor da casa: ',
                        style: TextStyle(),
                      ),
                      Obx(() => Switch(
                            activeColor: Colors.orange.shade700,
                            inactiveThumbColor: Colors.orange.shade500,
                            inactiveTrackColor: Colors.orange.shade100,
                            value: controller.provedorCheckboxValue.value,
                            onChanged: (value) {
                              controller.provedorCheckboxValue.value = value;
                            },
                          )),
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
                        return 'Por favor, digite o nome do morador';
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
                          items: ['Masculino', 'Feminino', 'Não informado']
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
                      Obx(
                        () => SizedBox(
                          width:
                              150, // Defina uma largura específica para o DropdownButtonFormField
                          child: DropdownButtonFormField<int>(
                            onTap: () async {
                              await peopleController
                                  .getMaritalStatus(); // Chama o método ao abrir o dropdown
                            },
                            value: controller.estadoCivilSelected.value,
                            onChanged: (value) {
                              controller.estadoCivilSelected.value = value!;
                            },
                            items: peopleController.listMaritalStatus
                                .map<DropdownMenuItem<int>>((item) {
                              return DropdownMenuItem<int>(
                                value: item.id,
                                child: Text(item.descricao ?? ''),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Estado Civil',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          maxLength: 10,
                          controller: controller.nascimentoPessoaController,
                          decoration: const InputDecoration(
                              errorMaxLines: 6,
                              counterText: "",
                              border: OutlineInputBorder(),
                              labelText: 'Data de Nascimento'),
                          onChanged: (value) =>
                              controller.onNascimentoChanged(value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Data inválida';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: controller.parentesco.value,
                          onChanged: (value) {},
                          items: [
                            'Avô(ó)',
                            'Bisavô(ó)',
                            'Companheiro(a)',
                            'Cunhado(a)',
                            'Irmã',
                            'Irmão',
                            'Madrasta',
                            'Mãe',
                            'Outro',
                            'Padrasto',
                            'Pai',
                            'Resp. Legal',
                            'Madrasta',
                            'Sobrinho(a)',
                            'Tio(a)',
                            'Vodrasto',
                            'Vodrasta',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Parentesco'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.cpfPessoaController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    onChanged: (value) => controller.onCPFChanged(value),
                    decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        labelText: 'CPF'),
                    // validator: (value) {
                    //   if (!controller.validateCPF()) {
                    //     return "Informe um CPF válido";
                    //   }
                    //   return null;
                    // },
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
                          maxLength: 15,
                          controller: controller.celularPessoaController,
                          decoration: const InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(),
                              labelText: 'Telefone'),
                          onChanged: (value) =>
                              controller.onPhoneChanged(value),
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
                  Obx(
                    () => DropdownButtonFormField<int>(
                      onTap: () async {
                        peopleController.getReligion();
                      },
                      value: controller.religiaoSelected.value,
                      onChanged: (value) {
                        controller.religiaoSelected.value = value!;
                      },
                      items: peopleController.listReligion
                          .map<DropdownMenuItem<int>>((item) {
                            print(item.id);
                            return DropdownMenuItem<int>(
                              value: item
                                  .id, // Suponha que seus dados tenham um campo 'value'
                              child: Text(item.descricao ??
                                  ''), // Suponha que seus dados tenham um campo 'label'
                            );
                          })
                          .toSet()
                          .toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Religião'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      peopleController.getChurch();
                    },
                    child: SearchField(
                      suggestionDirection: SuggestionDirection.flex,
                      controller: controller.igrejaPessoaController,
                      onSearchTextChanged: (query) {
                        final filter = peopleController.suggestions
                            .where((element) => element
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                        return filter
                            .map((e) => SearchFieldListItem<String>(e,
                                child: peopleController.searchChild(e)))
                            .toList();
                      },
                      onTap: () {},
                      key: const Key('searchfield'),
                      hint: 'Selecione uma Igreja',
                      itemHeight: 50,
                      scrollbarDecoration: ScrollbarDecoration(),
                      onTapOutside: (x) {
                        peopleController.focus.unfocus();
                      },
                      suggestionStyle:
                          const TextStyle(fontSize: 18, color: Colors.black),
                      searchStyle:
                          const TextStyle(fontSize: 18, color: Colors.black),
                      searchInputDecoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      suggestionsDecoration: SuggestionDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.grey),
                      ),
                      suggestions: peopleController.suggestions
                          .map((e) => SearchFieldListItem<String>(e,
                              child: peopleController.searchChild(e)))
                          .toList(),
                      focusNode: peopleController.focus,
                      suggestionState: Suggestion.expand,
                      onSuggestionTap: (SearchFieldListItem<String> x) {
                        peopleController.focus.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.funcaoIgrejaPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Função/Igreja'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'CANCELAR',
                            style: CustomTextStyle.button2(context),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.addPessoa(context);
                              controller.familyInfo.value = false;

                              //Get.back();
                            }
                          },
                          child: Text(
                            'ADICIONAR',
                            style: CustomTextStyle.button(context),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPersonCard extends StatelessWidget {
  final Pessoas pessoa;

  const CustomPersonCard({
    Key? key,
    required this.pessoa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildText('PROVEDDOR: ', pessoa.provedor_casa, context),
        buildText('PARENTESCO: ', pessoa.parentesco, context),
        buildText('SEXO: ', pessoa.sexo, context),
        buildText('ESTADO CIVIL: ', pessoa.estadocivil_id.toString(), context),
        buildText('NASCIMENTO: ', pessoa.data_nascimento, context),
        buildText('CPF: ', pessoa.cpf, context),
        buildText('TITULO: ', pessoa.titulo_eleitor, context),
        buildText('ZONA ELEITORAL: ', pessoa.zona_eleitoral, context),
        buildText('LOCAL TRABALHO: ', pessoa.local_trabalho, context),
        buildText('CARGO: ', pessoa.cargo_trabalho, context),
        buildText('TELEFONE: ', pessoa.telefone, context),
        buildText('REDE SOCIAL: ', pessoa.rede_social, context),
        buildText('RELIGIÃO: ', pessoa.religiao_id.toString(), context),
        buildText('IGREJA: ', pessoa.igreja_id.toString(), context),
        buildText('FUNÇÃO IGREJA: ', pessoa.funcao_igreja, context),
        // ... Adicione mais campos conforme necessário
      ],
    );
  }

  Widget buildText(String label, String? value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Text(
        '$label: ${value ?? ''}',
        style: CustomTextStyle.form(context),
      ),
    );
  }
}
