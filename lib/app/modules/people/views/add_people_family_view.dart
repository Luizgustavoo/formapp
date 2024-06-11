// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/widgets/custom_camera_modal.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/connection_service.dart';
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
                        ()  {

                          final status =
                              Get.find<InternetStatusProvider>().status;


                            return ClipOval(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: controller.isImagePicPathSet ==
                                    true
                                    ? FileImage(File(controller.photoUrlPath.value))
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

                                      if(status == InternetStatus.connected){
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => CustomCameraModal(
                                            tyContext: 'pessoa',
                                          ),
                                        );
                                      }else{
                                        Get.snackbar('Atenção', 'Conecte-se a internet para adicionar uma imagem!',
                                            colorText: Colors.white,
                                            backgroundColor: Colors.orange,
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration: Duration(seconds: 3),
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
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              errorMaxLines: 6,
                              counterText: "",
                              border: OutlineInputBorder(),
                              labelText: 'Data de Nascimento'),
                          onChanged: (value) =>
                              controller.onNascimentoChanged(value),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !FormattersValidators.validateDateSubmited(
                                    value)) {
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o cpf";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
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
                              labelText: 'Rede Social @'),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                        "Acometimento de Saúde",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppinss',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Religião'),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      border: const OutlineInputBorder(),
                      labelText: 'Igreja',
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.funcaoIgrejaPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Função/Igreja'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.localTrabalhoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Local de Trabalho'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.cargoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Cargo'),
                  ),
                  const SizedBox(height: 8),
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
}
