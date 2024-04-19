import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

import '../../modules/user/user_controller.dart';

class AproveUserModal extends GetView<UserController> {
  final User? user;
  final int? idMensagem;
  final familyController = Get.put(FamilyController());
  final int? idAprovacao;

  AproveUserModal({super.key, this.user, this.idMensagem, this.idAprovacao});
  @override
  Widget build(BuildContext context) {
    familyController.getFamiliesDropDown();
    RxInt typeUserSelected = 1.obs;
    RxInt? familyUser = 0.obs;
    controller.getTypeUser();
    return Form(
        key: controller.userFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'Aprovar Usuário',
                  style: CustomTextStyle.title(context),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Divider(
                  height: 5,
                  thickness: 3,
                  color: Color(0xFF1C6399),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => SizedBox(
                  child: DropdownButtonFormField<int>(
                    value: typeUserSelected.value,
                    onChanged: (value) {
                      typeUserSelected.value = value!;
                    },
                    items: controller.listTypeUsers
                        .map<DropdownMenuItem<int>>((item) {
                      return DropdownMenuItem<int>(
                        value: item.id,
                        child: Text(item.descricao ?? ''),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tipo Usuário',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => IgnorePointer(
                  ignoring: typeUserSelected.value != 3,
                  child: Opacity(
                    opacity: typeUserSelected.value == 3 ? 1.0 : 0.5,
                    child: DropdownButtonFormField<int>(
                      isDense: true,
                      menuMaxHeight: Get.size.height / 2,
                      value: user?.familiaId ??
                          (familyController.listFamiliesDropDown.isNotEmpty
                              ? familyController.listFamiliesDropDown.first.id
                              : null),
                      onChanged: (int? value) {
                        if (value != null) {
                          familyUser.value = value;
                        }
                      },
                      items: familyController.listFamiliesDropDown
                          .map<DropdownMenuItem<int>>((Family family) {
                        return DropdownMenuItem<int>(
                          value: family.id,
                          child: Text(family.nome!),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Família'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(110, 30),
                          backgroundColor: Colors.red.shade500),
                      onPressed: () async {
                        Map<String, dynamic> retorno =
                            await controller.approveUser(
                                typeUserSelected.value,
                                idAprovacao!,
                                idMensagem!,
                                UserStorage.getUserId(),
                                familyUser.value,
                                'negar');

                        if (retorno['return'] == 0) {
                          Get.back();
                        }
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 3000),
                          retorno['return'] == 0 ? 'Sucesso' : "Falha",
                          retorno['message'],
                          backgroundColor: retorno['return'] == 0
                              ? Colors.green
                              : Colors.red,
                          colorText: Colors.white,
                        );
                      },
                      child: Text(
                        'NEGAR',
                        style: CustomTextStyle.button(context),
                      )),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(110, 30)),
                      onPressed: () async {
                        Map<String, dynamic> retorno =
                            await controller.approveUser(
                                typeUserSelected.value,
                                idAprovacao!,
                                idMensagem!,
                                UserStorage.getUserId(),
                                familyUser.value,
                                'aprovar');

                        if (retorno['return'] == 0) {
                          Get.back();
                        }
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 3000),
                          retorno['return'] == 0 ? 'Sucesso' : "Falha",
                          retorno['message'],
                          backgroundColor: retorno['return'] == 0
                              ? Colors.green
                              : Colors.red,
                          colorText: Colors.white,
                        );
                      },
                      child: Text(
                        'APROVAR',
                        style: CustomTextStyle.button(context),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
