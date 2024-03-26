import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class CustomCameraModal extends StatelessWidget {
  final PeopleController controller = Get.put(PeopleController());
  final UserController userController = Get.put(UserController());
  CustomCameraModal({super.key, required this.tyContext});

  final String? tyContext;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      height: size.height * 0.2,
      child: Column(
        children: [
          Text(
            'Selecione sua foto de Perfil',
            style: CustomTextStyle.title(context),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_rounded, size: 60),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Galeria',
                      style: CustomTextStyle.button2(context),
                    )
                  ],
                ),
                onTap: () {
                  tyContext == 'pessoa'
                      ? controller.takePhoto(ImageSource.gallery)
                      : userController.takePhoto(ImageSource.gallery);
                  Get.back();
                },
              ),
              const SizedBox(
                width: 80,
              ),
              InkWell(
                child: Column(
                  children: [
                    const Icon(Icons.camera_rounded, size: 60),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Camera',
                      style: CustomTextStyle.button2(context),
                    )
                  ],
                ),
                onTap: () {
                  tyContext == 'pessoa'
                      ? controller.takePhoto(ImageSource.camera)
                      : userController.takePhoto(ImageSource.camera);
                  Get.back();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
