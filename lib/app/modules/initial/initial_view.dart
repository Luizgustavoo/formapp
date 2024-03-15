import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:formapp/app/modules/initial/initial_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

import 'package:get/get.dart';

class InitialView extends GetView<InitialController> {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logoWidth: 100,
      loaderColor: Colors.black54,
      logo: Image.asset(
        'assets/images/logo_splash.png',
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: Text(
        "Carregando...",
        style: CustomTextStyle.subtitle(context),
      ),
      navigator: controller.verifyAuth(),
      durationInSeconds: 3,
    );
  }
}
