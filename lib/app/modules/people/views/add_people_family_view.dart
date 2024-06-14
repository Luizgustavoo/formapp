// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/widgets/custom_camera_modal.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/format_validator.dart';

class AddPeopleFamilyView extends GetView<PeopleController> {
  const AddPeopleFamilyView({
    super.key,
    this.family,
    required this.tipoOperacao,
    required this.peopleLocal,
  });

  final Family? family;
  final int tipoOperacao;
  final bool peopleLocal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: controller.peopleFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tipoOperacao == 0 ? "Adicionar Pessoa" : "Alterar Pessoa",
                    style: CustomTextStyle.title(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Divider(
                      height: 5,
                      thickness: 3,
                      color: Color(0xFF014acb),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          final status =
                              Get.find<InternetStatusProvider>().status;

                          return ClipOval(
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: controller.isImagePicPathSet ==
                                      true
                                  ? FileImage(
                                      File(controller.photoUrlPath.value))
                                  : (controller.photoUrlPath.value.isNotEmpty
                                      ? NetworkImage(
                                              '$urlImagem/storage/app/public/${controller.photoUrlPath.value}')
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
                                    if (status == InternetStatus.connected) {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => CustomCameraModal(
                                          tyContext: 'pessoa',
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Atenção',
                                        'Conecte-se a internet para adicionar uma imagem!',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.orange,
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 70),
                      Text(
                        'Provedor: ',
                        style: CustomTextStyle.button2(context),
                      ),
                      Obx(() => Switch(
                            activeColor: Colors.blue.shade700,
                            inactiveThumbColor: Colors.blue.shade500,
                            inactiveTrackColor: Colors.blue.shade100,
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
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.person),
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                      labelText: 'NOME',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o nome do morador';
                      }
                      return null;
                    },
                  ),
                  _gap(),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.sexo.value,
                        onChanged: (value) {
                          controller.sexo.value = value!;
                        },
                        items: ['Masculino', 'Feminino', 'Não informado']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'SEXO'),
                      )),
                  _gap(),
                  Obx(
                    () => DropdownButtonFormField<int>(
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
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'ESTADO CIVIL'),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    maxLength: 10,
                    controller: controller.nascimentoPessoaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorMaxLines: 6,
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                        suffixIcon: const Icon(Icons.calendar_month_rounded),
                        labelText: 'DATA DE NASCIMENTO'),
                    onChanged: (value) => controller.onNascimentoChanged(value),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !FormattersValidators.validateDateSubmited(value)) {
                        return 'Data inválida';
                      }
                      return null;
                    },
                  ),
                  _gap(),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      isDense: true,
                      menuMaxHeight: Get.size.height / 2,
                      value: controller.parentesco?.value,
                      onChanged: (value) {
                        controller.parentesco?.value = value!;
                      },
                      items: <String>[
                        'Avô(ó)',
                        'Bisavô(ó)',
                        'Companheiro(a)',
                        'Cunhado(a)',
                        'Filho(a)',
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Parentesco',
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: controller.cpfPessoaController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    onChanged: (value) => controller.onCPFChanged(value),
                    decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: const Icon(Icons.view_timeline_rounded),
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                        labelText: 'CPF'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o cpf";
                      }
                      return null;
                    },
                  ),
                  _gap(),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          controller: controller.celularPessoaController,
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: const Icon(Icons.phone),
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                              labelText: 'TELEFONE'),
                          onChanged: (value) =>
                              controller.onPhoneChanged(value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: controller.redeSocialPessoaController,
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: const Icon(Icons.alternate_email),
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                              labelText: 'REDE SOCIAL'),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  _gap(),
                  Obx(
                    () => MultiSelectBottomSheetField(
                      initialValue: controller.selectedSaudeIds,
                      selectedColor: const Color(0xFF014acb),
                      isDismissible: false,
                      searchable: true,
                      items: controller.listHealth.map((item) {
                        return MultiSelectItem(item.id, item.nome ?? '');
                      }).toList(),
                      selectedItemsTextStyle: const TextStyle(
                          color: Colors.black, fontFamily: 'Poppinss'),
                      listType: MultiSelectListType.LIST,
                      searchHint: 'Pesquisar',
                      onConfirm: (values) {
                        controller.selectedSaudeIds.value =
                            List<int>.from(values);
                      },
                      title: const Text(''),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      cancelText: const Text(
                        'CANCELAR',
                        style: TextStyle(
                            fontFamily: 'Poppinss', color: Color(0xFF014acb)),
                      ),
                      confirmText: const Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: 'Poppinss', color: Color(0xFF014acb)),
                      ),
                      buttonIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      buttonText: const Text(
                        "Problemas de Saúde",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppinss',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  Obx(
                    () => MultiSelectBottomSheetField(
                      initialValue: controller.selectedMedicamentoIds,
                      selectedColor: const Color(0xFF014acb),
                      isDismissible: false,
                      searchable: true,
                      items: controller.listMedicine.map((item) {
                        return MultiSelectItem(item.id, item.nome ?? '');
                      }).toList(),
                      selectedItemsTextStyle: const TextStyle(
                          color: Colors.black, fontFamily: 'Poppinss'),
                      listType: MultiSelectListType.LIST,
                      searchHint: 'Pesquisar',
                      onConfirm: (values) {
                        controller.selectedMedicamentoIds.value =
                            List<int>.from(values);
                      },
                      title: const Text(''),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      cancelText: const Text(
                        'CANCELAR',
                        style: TextStyle(
                            fontFamily: 'Poppinss', color: Color(0xFF014acb)),
                      ),
                      confirmText: const Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: 'Poppinss', color: Color(0xFF014acb)),
                      ),
                      buttonIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      buttonText: const Text(
                        "Uso de Medicamento",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppinss',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: controller.religiaoSelected.value,
                      onChanged: (value) {
                        controller.religiaoSelected.value = value!;
                      },
                      items: controller.listReligion
                          .map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item.id,
                              child: Text(item.descricao ?? ''),
                            );
                          })
                          .toSet()
                          .toList(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'RELIGIÃO'),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: controller.igrejaPessoaController,
                    readOnly: true,
                    onTap: () async {
                      final selectedChurch = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Selecione uma Igreja'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: controller.suggestions
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e),
                                        onTap: () {
                                          Navigator.of(context).pop(e);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      );

                      if (selectedChurch != null) {
                        controller.igrejaPessoaController.text = selectedChurch;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'IGREJA',
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () async {
                          final selectedChurch = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Selecione uma Igreja',
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: controller.suggestions
                                        .map(
                                          (e) => ListTile(
                                            title: Text(
                                              e,
                                              style:
                                                  const TextStyle(fontSize: 30),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop(e);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          );

                          if (selectedChurch != null) {
                            controller.igrejaPessoaController.text =
                                selectedChurch;
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecione uma igreja';
                      }
                      return null;
                    },
                  ),
                  _gap(),
                  TextFormField(
                    controller: controller.funcaoIgrejaPessoaController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                        suffixIcon: const Icon(Icons.church_rounded),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'FUNÇÃO/IGREJA'),
                  ),
                  _gap(),
                  TextFormField(
                      controller: controller.localTrabalhoPessoaController,
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(Icons.maps_home_work_rounded),
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                          labelText: 'LOCAL/TRABALHO')),
                  _gap(),
                  TextFormField(
                      controller: controller.cargoPessoaController,
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(Icons.work),
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                          ),
                          labelText: 'CARGO')),
                  _gap(),
                  Obx(() {
                    final familyController = Get.put(FamilyController());
                    final status = Get.find<InternetStatusProvider>().status;
                    bool isConnected = status == InternetStatus.connected;
                    if (status != InternetStatus.connected) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Get.snackbar(
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                          'Aviso',
                          'Você precisa estar conectado à internet para selecionar uma família.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      });
                    }
                    // Retorna o DropdownButtonFormField com base no status da internet
                    return DropdownButtonFormField<int>(
                      isDense: true,
                      menuMaxHeight: Get.size.height / 2,
                      value: controller.familySelected!.value > 0
                          ? controller.familySelected!.value
                          : null,
                      onChanged: isConnected
                          ? (int? value) {
                              if (value != null) {
                                controller.familySelected!.value = value;
                              }
                            }
                          : null, // Desabilita a alteração se não estiver conectado
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Selecione uma família'),
                        ),
                        ...familyController.listFamilies
                            .map<DropdownMenuItem<int>>((Family family) {
                          return DropdownMenuItem<int>(
                            value: family.id,
                            child: Text(family.nome!),
                          );
                        }).toList(),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Família',
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                  _gap(),
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
                          onPressed: controller.isSaving.value
                              ? null
                              : () async {
                                  Map<String, dynamic> retorno =
                                      tipoOperacao == 0
                                          ? await controller.savePeople(
                                              family, peopleLocal)
                                          : await controller
                                              .updatePeople(peopleLocal);
                                  if (retorno['return'] == 0) {
                                    Get.offAllNamed('/list-people');
                                  }
                                  Get.snackbar(
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    retorno['return'] == 0
                                        ? 'Sucesso'
                                        : "Falha",
                                    retorno['message'],
                                    backgroundColor: retorno['return'] == 0
                                        ? Colors.green
                                        : Colors.red,
                                    colorText: Colors.white,
                                  );
                                },
                          child: controller.isSaving.value
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF1C6399)),
                                )
                              : Text(
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

  Widget _gap() => const SizedBox(height: 8);
}
