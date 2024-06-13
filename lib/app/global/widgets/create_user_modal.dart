import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

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

  final RxInt typeUserSelected = 1.obs;

  @override
  Widget build(BuildContext context) {
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
                  return controller.validateName(value);
                },
                controller: controller.nameController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
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
                height: 10,
              ),
              if (UserStorage.getUserType() == 1) ...[
                Obx(
                  () => SizedBox(
                    child: DropdownButtonFormField<int>(
                      value: typeUserSelected.value,
                      onChanged: (value) {
                        typeUserSelected.value = value!;
                      },
                      items: controller.listTypeUsers
                          // .where((item) => item.id != 3)
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
                        Map<String, dynamic> retorno = tipoOperacao == 'insert'
                            ? await controller.saveUser()
                            : await controller.updateUser(
                                user!.id!, typeUserSelected.value);

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
