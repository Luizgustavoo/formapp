import 'package:flutter/material.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomBottomSheet extends StatelessWidget {
  final EditPeopleController controller = Get.find();
  CustomBottomSheet({super.key});

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
                  controller.takePhoto(ImageSource.gallery);
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
                  controller.takePhoto(ImageSource.camera);
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
