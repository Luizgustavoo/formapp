import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/modules/login/login_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class SignUpView extends GetView<LoginController> {
  const SignUpView({super.key});

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
                              spreadRadius: 50,
                            ),
                          ],
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 0,
                          ),
                          child: Form(
                            key: controller.signupKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => TextFormField(
                                        controller: controller.nameSignUpCtrl,
                                        enabled: !controller.isLoggingIn.value,
                                        validator: (value) {
                                          return controller.validateName(value);
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'NOME',
                                          labelStyle: const TextStyle(
                                              color: Colors.black54,
                                              fontFamily: 'Poppins',
                                              fontSize: 16),
                                          hintText: 'Digite seu nome...',
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
                                      )),
                                  _gap(),
                                  Obx(() => TextFormField(
                                        controller:
                                            controller.usernameSignUpCtrl,
                                        validator: (value) {
                                          return controller
                                              .validateUsername(value);
                                        },
                                        enabled: !controller.isLoggingIn.value,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'E-MAIL',
                                          labelStyle: const TextStyle(
                                              color: Colors.black54,
                                              fontFamily: 'Poppins',
                                              fontSize: 16),
                                          hintText: 'Digite seu e-mail...',
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
                                      )),
                                  _gap(),
                                  Obx(() => TextFormField(
                                        controller:
                                            controller.passwordSignUpCtrl,
                                        validator: (value) {
                                          return controller.validatePassword(
                                              value, false);
                                        },
                                        enabled: !controller.isLoggingIn.value,
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
                                  Obx(() => TextFormField(
                                        controller: controller
                                            .confirmPasswordSignUpCtrl,
                                        validator: (value) {
                                          return controller.validatePassword(
                                              value, false);
                                        },
                                        enabled: !controller.isLoggingIn.value,
                                        obscureText: !controller
                                            .confirmPasswordVisible.value,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            isDense: true,
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'REPITA SUA SENHA',
                                            labelStyle: const TextStyle(
                                                color: Colors.black54,
                                                fontFamily: 'Poppins',
                                                fontSize: 16),
                                            hintText:
                                                'Digite novamente sua senha...',
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
                                                              .confirmPasswordVisible
                                                              .value
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                      color: Colors.black54),
                                                  onPressed: () {
                                                    controller
                                                            .confirmPasswordVisible
                                                            .value =
                                                        !controller
                                                            .confirmPasswordVisible
                                                            .value;
                                                  },
                                                ))),
                                      )),
                                  const SizedBox(height: 15),
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
                                              'CADASTRAR',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Map<String, dynamic> retorno =
                                                await controller.signUp();

                                            if (retorno['return'] == 0) {
                                              Get.back();
                                            }
                                            Get.snackbar(
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration: const Duration(
                                                  milliseconds: 6000),
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
                                  const SizedBox(height: 15),
                                  Text(
                                    'Já possui uma conta?',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.subjectMessageNegrit(
                                        context),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 50,
                                    child: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'FAZER LOGIN',
                                          style: CustomTextStyle.buttonSignUp(
                                              context),
                                        )),
                                  )
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
}
