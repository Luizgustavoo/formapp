// ignore_for_file: public_member_api_docs, sort_constructors_first, unrelated_type_equality_checks
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

import 'package:formapp/app/global/widgets/custom_bottomsheet_file.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

class AddPeopleFamilyView extends GetView<PeopleController> {
  const AddPeopleFamilyView(
      {super.key, this.family, required this.tipoOperacao});

  final Family? family;
  final int tipoOperacao;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.peopleFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipoOperacao == 0 ? "Adicionar Membro" : "Alterar Membro",
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
                      Obx(
                        () => CircleAvatar(
                          radius: 35,
                          backgroundImage: controller.isImagePicPathSet == true
                              ? FileImage(File(controller.photoUrlPath.value))
                              : (controller.photoUrlPath.value.isNotEmpty
                                  ? NetworkImage(
                                          '$urlImagem/public/storage/${controller.photoUrlPath.value}')
                                      as ImageProvider<Object>?
                                  : const AssetImage(
                                      'assets/images/default_avatar.jpg')),
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
                                  builder: (context) => CustomBottomSheet(),
                                );
                              },
                            ),
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
                        child: Obx(() => DropdownButtonFormField<String>(
                              value: controller.sexo.value,
                              onChanged: (value) {
                                controller.sexo.value = value!;
                              },
                              items: [
                                'Masculino',
                                'Feminino',
                                'Não informado'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Sexo'),
                            )),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<int>(
                            onTap: () async {
                              await controller.getMaritalStatus();
                            },
                            value: controller.estadoCivilSelected.value,
                            onChanged: (value) {
                              controller.estadoCivilSelected.value = value!;
                            },
                            items: controller.listMaritalStatus
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
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            isDense: true,
                            menuMaxHeight: Get.size.height / 2,
                            value: controller.parentesco.value,
                            onChanged: (value) {
                              controller.parentesco.value = value!;
                            },
                            items: <String>[
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
                      )
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
                        controller.getReligion();
                      },
                      value: controller.religiaoSelected.value,
                      onChanged: (value) {
                        controller.religiaoSelected.value = value!;
                      },
                      items: controller.listReligion
                          .map<DropdownMenuItem<int>>((item) {
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
                      controller.getChurch();
                    },
                    child: SearchField(
                      suggestionDirection: SuggestionDirection.flex,
                      controller: controller.igrejaPessoaController,
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
                      key: const Key('searchfield'),
                      hint: 'Selecione uma Igreja',
                      itemHeight: 50,
                      scrollbarDecoration: ScrollbarDecoration(),
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
                          onPressed: () async {
                            Map<String, dynamic> retorno = tipoOperacao == 0
                                ? await controller.savePeople(family!)
                                : await controller.updatePeople();
                            if (retorno['return'] == 0) {
                              Get.back();
                            }
                            Get.snackbar(
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(milliseconds: 1500),
                              retorno['return'] == 0 ? 'Sucesso' : "Falha",
                              retorno['message'],
                              backgroundColor: retorno['return'] == 0
                                  ? Colors.green
                                  : Colors.red,
                              colorText: Colors.white,
                            );
                          },
                          child: Text(
                            tipoOperacao == 0 ? "ADICIONAR" : "ALTERAR",
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
