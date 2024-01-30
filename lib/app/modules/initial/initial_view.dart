import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:formapp/app/modules/initial/initial_controller.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:formapp/app/screens/home_page.dart';
import 'package:get/get.dart';

class InitialView extends GetView<InitialController> {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
          'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
      title: const Text(
        "Title",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: controller.verifyAuth(),
      durationInSeconds: 3,
    );
  }
}
