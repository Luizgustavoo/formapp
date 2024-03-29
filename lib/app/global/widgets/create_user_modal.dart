import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CreateUserModal extends StatelessWidget {
  CreateUserModal({
    super.key,
    this.user,
    required this.titulo,
    this.tipoOperacao,
  });

  final controller = Get.find<UserController>();
  final familyController = Get.put(FamilyController());
  final homeController = Get.put(HomeController());

  final User? user;
  final String? titulo;
  final String? tipoOperacao;

  @override
  Widget build(BuildContext context) {
    final familiaId = familyController.box.read('auth')['user']['familia_id'];
    final selectedFamily = familyController.selectedFamily;
    return Form(
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
                  titulo!,
                  style: CustomTextStyle.title(context),
                ),
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
                validator: (value) {
                  return controller.validateName(value);
                },
                controller: controller.nameController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                enabled: tipoOperacao == 'update' ? false : true,
                validator: (value) {
                  return controller.validateLogin(value);
                },
                controller: controller.usernameController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Login',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() => TextFormField(
                    validator: (value) {
                      return controller.validatePassword(value);
                    },
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                        suffixIcon: Obx(() => IconButton(
                              icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54),
                              onPressed: () {
                                controller.isPasswordVisible.value =
                                    !controller.isPasswordVisible.value;
                              },
                            )),
                        labelText: 'Senha',
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 8,
              ),
              if (familiaId == null) ...[
                Obx(
                  () => DropdownButtonFormField<int>(
                    isDense: true,
                    menuMaxHeight: Get.size.height / 2,
                    value: user?.family?.id,
                    onChanged: (int? value) {
                      controller.selectedFamily!.value = value!;
                    },
                    items: familyController.listFamilies
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
              ],
              const SizedBox(
                height: 16,
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
                            ? await controller.saveUser()
                            : await controller.updateUser(user!.id!);

                        if (tipoOperacao == 'update' &&
                            retorno['return'] == 0 &&
                            user!.id == UserStorage.getUserId()) {
                          homeController.logout();
                        }
                        if (tipoOperacao == 'insert' &&
                            retorno['return'] == 0) {
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
                        tipoOperacao == 'insert' ? 'SALVAR' : 'ALTERAR',
                        style: CustomTextStyle.button(context),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
