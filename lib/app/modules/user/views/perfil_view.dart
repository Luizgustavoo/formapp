// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_camera_modal.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class PerfilView extends GetView<UserController> {
  PerfilView({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
      ),
      body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(15), topEnd: Radius.circular(15))),
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
                          backgroundImage: controller.isImagePicPathSet == true
                              ? FileImage(File(controller.photoUrlPath.value))
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
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => CustomCameraModal(
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
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'Nome',
                          labelStyle:
                              CustomTextStyle.textFormFieldStyle(context),
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
                              CustomTextStyle.textFormFieldStyle(context),
                          fillColor: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'Senha',
                          labelStyle:
                              CustomTextStyle.textFormFieldStyle(context),
                          fillColor: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> retorno =
                                await controller.updateUser(
                                    UserStorage.getUserId(),
                                    UserStorage.getUserType());

                            if (retorno['return'] == 0) {
                              controller.logout();
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
                          child: const Text(
                            'SALVAR',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppinss',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
