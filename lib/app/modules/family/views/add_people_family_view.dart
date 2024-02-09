import 'package:flutter/material.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';

import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class AddPeopleFamilyView extends GetView<EditPeopleController> {
  const AddPeopleFamilyView({super.key, required this.familyController});

  final FamilyController familyController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: familyController.formKey,
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
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            familyController.photoUrl.value.isNotEmpty
                                ? NetworkImage(familyController.photoUrl.value)
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
                        value: familyController.provedorCheckboxValue.value,
                        onChanged: (value) {
                          familyController.provedorCheckboxValue.value = value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: familyController.nomePessoaController,
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
                          value: familyController.sexo.value,
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
                            value: familyController.estadoCivilSelected.value,
                            onChanged: (value) {
                              familyController.estadoCivilSelected.value =
                                  value!;
                            },
                            items: controller.listMaritalStatus.map((item) {
                              print("ID do Estado Civil: ${item.id}");
                              print(
                                  "Descrição do Estado Civil: ${item.descricao}");
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
                      // Obx(
                      //   () => Expanded(
                      //     child: DropdownButtonFormField<int>(
                      //       value: familyController.estadoCivilSelected.value,
                      //       onChanged: (value) {
                      //         familyController.estadoCivilSelected.value =
                      //             value!;
                      //       },
                      //       items: controller.listMaritalStatus
                      //           .map<DropdownMenuItem<int>>((item) {
                      //             print(item.id);
                      //             return DropdownMenuItem<int>(
                      //               value: item
                      //                   .id, // Suponha que seus dados tenham um campo 'value'
                      //               child: Text(item.descricao ??
                      //                   ''), // Suponha que seus dados tenham um campo 'label'
                      //             );
                      //           })
                      //           .toSet()
                      //           .toList(),
                      //       decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: 'Estado Civil'),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller:
                              familyController.nascimentoPessoaController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Data de Nascimento'),
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: familyController.parentesco.value,
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
                    controller: familyController.cpfPessoaController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    onChanged: (value) => familyController.onCPFChanged(value),
                    decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        labelText: 'CPF'),
                    validator: (value) {
                      if (!familyController.validateCPF()) {
                        return "Informe um CPF válido";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller:
                              familyController.tituloEleitoralPessoaController,
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
                          controller:
                              familyController.zonaEleitoralPessoaController,
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
                    controller: familyController.localTrabalhoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Trabalho'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: familyController.cargoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Cargo'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: familyController.celularPessoaController,
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
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: familyController.religiaoSelected.value,
                      onChanged: (value) {
                        familyController.religiaoSelected.value = value!;
                      },
                      items: controller.listReligion
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
                  SearchField(
                    suggestionDirection: SuggestionDirection.flex,
                    onSearchTextChanged: (query) {
                      final filter = controller.suggestions
                          .where((element) => element
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                      return filter
                          .map((e) => SearchFieldListItem<String>(e,
                              child: controller.searchChild(e)))
                          .toList();
                    },
                    onTap: () {},
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) {
                    //   if (value == null ||
                    //       controller.suggestions.contains(value.trim())) {
                    //     return 'Enter a valid country name';
                    //   }
                    //   return null;
                    // },
                    key: const Key('searchfield'),
                    hint: 'Selecione uma Igreja',

                    itemHeight: 50,
                    scrollbarDecoration: ScrollbarDecoration(),
                    //   thumbVisibility: true,
                    //   thumbColor: Colors.red,
                    //   fadeDuration: const Duration(milliseconds: 3000),
                    //   trackColor: Colors.blue,
                    //   trackRadius: const Radius.circular(10),
                    // ),
                    onTapOutside: (x) {
                      controller.focus.unfocus();
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
                    suggestions: controller.suggestions
                        .map((e) => SearchFieldListItem<String>(e,
                            child: controller.searchChild(e)))
                        .toList(),
                    focusNode: controller.focus,
                    suggestionState: Suggestion.expand,
                    onSuggestionTap: (SearchFieldListItem<String> x) {
                      controller.focus.unfocus();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: familyController.funcaoIgrejaPessoaController,
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
                            if (familyController.formKey.currentState!
                                .validate()) {
                              familyController.addPessoa();
                              familyController.familyInfo.value = false;
                              Get.back();
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
