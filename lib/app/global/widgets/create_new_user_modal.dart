import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class CreateNewUserModal extends StatelessWidget {
  CreateNewUserModal({super.key, this.user, required this.titulo, this.people});

  final controller = Get.find<UserController>();
  final familyController = Get.put(FamilyController());
  final homeController = Get.put(HomeController());

  final User? user;
  final String? titulo;
  final People? people;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Form(
          key: controller.userFormKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "${titulo!}: ${people?.nome}",
                    style: CustomTextStyle.titleModal(context),
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
                TextFormField(
                  validator: (value) {
                    return controller.validateLogin(value);
                  },
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      labelText: 'E-mail',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => TextFormField(
                    obscureText: !controller.isPasswordVisible.value,
                    validator: (value) {
                      return controller.validatePassword(value);
                    },
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: Obx(
                        () => IconButton(
                          icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54),
                          onPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (UserStorage.getUserType() == 1) ...[
                  Obx(
                    () => SizedBox(
                      child: DropdownButtonFormField<int>(
                        value: controller.typeUserSelected.value,
                        onChanged: (value) {
                          controller.typeUserSelected.value = value!;
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
                ],
                const SizedBox(
                  height: 10,
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
                          // if (typeUserSelected.value == 3 &&
                          //     controller.familyUser!.value <= 0) {
                          //   Get.snackbar('Atenção', 'Selecione uma família!',
                          //       backgroundColor: Colors.red,
                          //       colorText: Colors.white);
                          // } else {
                          Map<String, dynamic> retorno =
                              await controller.saveUserPeople(people!.nome!, people!.id!);

                          Get.back();

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
                          // }
                        },
                        child: Text(
                          'SALVAR',
                          style: CustomTextStyle.button(context),
                        )),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
