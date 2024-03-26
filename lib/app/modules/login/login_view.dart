import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/modules/login/login_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/images/familia.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.darken))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image(
                        image: AssetImage('assets/images/logo_splash.png'))),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 18, left: 18, right: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              blurRadius: 80,
                              spreadRadius: 150,
                            ),
                          ],
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 0,
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: controller.usernameCtrl,
                                    validator: (value) {
                                      return controller.validateUsername(value);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'USUÁRIO',
                                      labelStyle: const TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontSize: 16),
                                      hintText: 'Digite seu usuário...',
                                      hintStyle: const TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontSize: 12),
                                      suffixIcon: const Icon(
                                          Icons.email_rounded,
                                          color: Colors.black54),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                  _gap(),
                                  Obx(() => TextFormField(
                                        controller: controller.passwordCtrl,
                                        validator: (value) {
                                          return controller
                                              .validatePassword(value);
                                        },
                                        obscureText:
                                            !controller.isPasswordVisible.value,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'SENHA',
                                            labelStyle: const TextStyle(
                                                color: Colors.black54,
                                                fontFamily: 'Poppins',
                                                fontSize: 16),
                                            hintText: 'Digite sua senha...',
                                            hintStyle: const TextStyle(
                                                color: Colors.black54,
                                                fontFamily: 'Poppins',
                                                fontSize: 12),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            suffixIcon: Obx(() => IconButton(
                                                  icon: Icon(
                                                      controller
                                                              .isPasswordVisible
                                                              .value
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.black54),
                                                  onPressed: () {
                                                    controller.isPasswordVisible
                                                            .value =
                                                        !controller
                                                            .isPasswordVisible
                                                            .value;
                                                  },
                                                ))),
                                      )),
                                  _gap(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 70,
                                    width: double.infinity,
                                    child: Obx(
                                      () => Visibility(
                                        visible: !controller.loading.value,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'ENTRAR',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Poppinss',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () {
                                            controller.login();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Visibility(
                                      visible: controller.loading.value,
                                      child: Container(
                                        color: Colors.transparent,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: double.infinity,
                                        height: 70,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          onPressed: null,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        showForgotPasswordModal(context);
                                      },
                                      child: Text(
                                        'Esqueceu a senha?',
                                        style: CustomTextStyle
                                            .subjectMessageNegrit(context),
                                      ))
                                ],
                              ),
                            ),
                          ),
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
    );
  }

  Widget _gap() => const SizedBox(height: 16);
  void showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Form(
                key: controller.forgotKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recuperar senha",
                        style: CustomTextStyle.title(context)),
                    const SizedBox(height: 20),
                    Text(
                      "Digite seu nome de usuário para recuperar a senha:",
                      style: CustomTextStyle.subtitle(context),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.forgotPasswordCtrl,
                      decoration: const InputDecoration(
                        labelText: "Usuário",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => controller.validateUsername(value),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> retorno =
                                await controller.forgotPassword(
                                    controller.forgotPasswordCtrl.text);

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
                          child: const Text(
                            "Recuperar",
                            style: TextStyle(
                                fontFamily: 'Poppinss', color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
