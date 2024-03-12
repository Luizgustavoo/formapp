import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/modules/people/views/add_people_family_view.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class CreateFamilyModal extends StatelessWidget {
  CreateFamilyModal({
    Key? key,
    this.family,
    required this.titulo,
    required this.tipoOperacao,
  }) : super(key: key);

  final Family? family;

  final String? titulo;
  final String? tipoOperacao;

  final FamilyController controller = Get.find();
  final PeopleController peopleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.familyFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titulo!,
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
                    keyboardType: TextInputType.number,
                    controller: controller.numeroCasaFamiliaController,
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
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      isDense: true,
                      menuMaxHeight: Get.size.height / 2,
                      value: controller.uf.value,
                      onChanged: (value) {
                        controller.uf.value = value!;
                      },
                      items: <String>[
                        'AC',
                        'AL',
                        'AP',
                        'AM',
                        'BA',
                        'CE',
                        'DF',
                        'ES',
                        'GO',
                        'MA',
                        'MT',
                        'MS',
                        'MG',
                        'PA',
                        'PB',
                        'PR',
                        'PE',
                        'PI',
                        'RJ',
                        'RN',
                        'RS',
                        'RO',
                        'RR',
                        'SC',
                        'SP',
                        'SE',
                        'TO',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'UF'),
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
                      Map<String, dynamic> retorno = tipoOperacao == 'insert'
                          ? await controller.saveFamily()
                          : await controller.updateFamily(family!.id!);

                      if (retorno['return'] == 0) {
                        Get.back();
                        peopleController.clearAllPeopleTextFields();
                        Future.delayed(const Duration(seconds: 1), () {
                          return showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            context: context,
                            builder: (context) => Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: AddPeopleFamilyView(
                                tipoOperacao: 0,
                                family: family,
                              ),
                            ),
                          );
                        });
                      }
                      Get.snackbar(
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(milliseconds: 1500),
                        retorno['return'] == 0 ? 'Sucesso' : "Falha",
                        retorno['message'],
                        backgroundColor:
                            retorno['return'] == 0 ? Colors.green : Colors.red,
                        colorText: Colors.white,
                      );
                    },
                    child: Text(
                      'SALVAR',
                      style: CustomTextStyle.button(context),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
