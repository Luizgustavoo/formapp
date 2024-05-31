// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_camera_modal.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class PerfilView extends GetView<UserController> {
  const PerfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: 'Perfil',
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFf1f5ff),
        ),
        child: Obx(
          () => Stack(
            children: [
              IgnorePointer(
                ignoring: controller.isSaving.value,
                child: Opacity(
                  opacity: controller.isSaving.value ? 0.5 : 1,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: controller.userFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Obx(
                                () => CircleAvatar(
                                  radius: 80,
                                  backgroundImage: controller
                                              .isImagePicPathSet ==
                                          true
                                      ? FileImage(
                                          File(controller.photoUrlPath.value))
                                      : (controller.photoUrlPath.value.isNotEmpty
                                          ? NetworkImage(
                                                  '$urlImagem/storage/app/public/${controller.photoUrlPath.value}')
                                              as ImageProvider<Object>?
                                          : const AssetImage(
                                              'assets/images/default_avatar.jpg')),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Material(
                                          color: const Color(0xFF1C6399),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    CustomCameraModal(
                                                  tyContext: 'perfil',
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.nameController,
                                enabled: !controller.isSaving.value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  labelText: 'Nome',
                                  labelStyle:
                                      CustomTextStyle.textFormFieldStyle(
                                          context),
                                  fillColor: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.usernameController,
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  labelText: 'Usuário',
                                  labelStyle:
                                      CustomTextStyle.textFormFieldStyle(
                                          context),
                                  fillColor: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.passwordController,
                                enabled: !controller.isSaving.value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  labelText: 'Senha',
                                  labelStyle:
                                      CustomTextStyle.textFormFieldStyle(
                                          context),
                                  fillColor: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 65,
                                child: ElevatedButton(
                                  onPressed: controller.isSaving.value
                                      ? null
                                      : () async {
                                          controller.isSaving.value = true;
                                          Map<String, dynamic> retorno =
                                              await controller.updateUser(
                                                  UserStorage.getUserId(),
                                                  UserStorage.getUserType());

                                          if (retorno['return'] == 0) {
                                            Get.offAllNamed('/home');
                                          }

                                          Get.snackbar(
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            retorno['return'] == 0
                                                ? 'Sucesso'
                                                : "Falha",
                                            retorno['message'],
                                            backgroundColor:
                                                retorno['return'] == 0
                                                    ? Colors.green
                                                    : Colors.red,
                                            colorText: Colors.white,
                                          );
                                          controller.isSaving.value = false;
                                        },
                                  child: controller.isSaving.value
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF1C6399)),
                                        )
                                      : const Text(
                                          'SALVAR',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Poppinss',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () {
                                  controller.logout();
                                },
                                icon: const Icon(Icons.exit_to_app_rounded),
                                label: const Text('SAIR'),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade400),
                                    onPressed: () {
                                      controller.deletePassword.text = "";
                                      Get.defaultDialog(
                                        title: 'Confirmar exclusão',
                                        content: Form(
                                          key: controller.deleteAccountKey,
                                          child: Column(
                                            children: [
                                              const Text(
                                                  'Tem certeza que deseja excluir sua conta?'),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'Digite sua senha'),
                                                obscureText: true,
                                                controller:
                                                    controller.deletePassword,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Campo obrigatório';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmTextColor: Colors
                                            .white, // Cor do texto do botão de confirmar
                                        cancelTextColor: Colors
                                            .black, // Cor do texto do botão de cancelar
                                        buttonColor: Colors.blue.shade400,
                                        textCancel: 'Cancelar',
                                        textConfirm: 'Confirmar',
                                        onCancel: () => Get.back(),
                                        onConfirm: () async {
                                          if (controller
                                              .deleteAccountKey.currentState!
                                              .validate()) {
                                            var mensagem = await controller
                                                .deleteAccount();

                                            if (mensagem == null) {
                                              Get.snackbar(
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  "Falha",
                                                  mensagem['message'],
                                                  backgroundColor: Colors.red);
                                            } else {
                                              if (mensagem["code"] == 0) {
                                                controller.logout();
                                                Get.snackbar(
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    "Sucesso",
                                                    mensagem['message'],
                                                    backgroundColor:
                                                        Colors.green);
                                              } else {
                                                Get.snackbar(
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    "Falha",
                                                    "Usuário e/ou senha inválidas!",
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                            }
                                          }
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Deletar minha conta",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppinss',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
