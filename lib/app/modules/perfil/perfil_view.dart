import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/global/widgets/custom_camera_modal.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/modules/perfil/perfil_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';

class PerfilView extends GetView<PerfilController> {
  PerfilView({Key? key}) : super(key: key);

  final peopleController = Get.find<PeopleController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
                child: Column(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 80,
                        backgroundImage: peopleController.isImagePicPathSet ==
                                true
                            ? FileImage(
                                File(peopleController.photoUrlPath.value))
                            : (peopleController.photoUrlPath.value.isNotEmpty
                                ? NetworkImage(
                                        '$urlImagem/public/storage/${peopleController.photoUrlPath.value}')
                                    as ImageProvider<Object>?
                                : const AssetImage(
                                    'assets/images/default_avatar.jpg')),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: const Color(0xFF123d68),
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
                                      builder: (context) => CustomCameraModal(),
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
                      initialValue: UserStorage.getUserName(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Nome',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: UserStorage.getUserLogin(),
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Usuário',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Senha',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Confirme a nova senha',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para salvar
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
                        homeController.logout();
                      },
                      icon: const Icon(Icons.exit_to_app_rounded),
                      label: const Text('SAIR'),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
