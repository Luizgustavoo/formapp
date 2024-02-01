import 'package:flutter/material.dart';
import 'package:formapp/app/modules/login/login_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/images/familia.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Colors.white.withAlpha(190),
                      child: Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        constraints: BoxConstraints(maxWidth: size.width),
                        child: Form(
                          key: controller.formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text("Acessar conta",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                      )),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ToggleSwitch(
                                      initialLabelIndex: 0,
                                      minWidth: 130,
                                      minHeight: 30.0,
                                      cornerRadius: 5.0,
                                      onToggle: (index) =>
                                          controller.onToggle.value = index!,
                                      labels: const ['CREDENCIADO', 'FAMILIAR'],
                                      activeBgColor: [Colors.orange.shade500],
                                      inactiveBgColor: Colors.transparent,
                                      customTextStyles: const [
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppinss',
                                            fontWeight: FontWeight.w900),
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppinss',
                                            fontWeight: FontWeight.w900)
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: controller.usernameCtrl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor digite seu usuário';
                                    }
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value);
                                    if (!emailValid) {
                                      return 'Digite um e-mail válido';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Usuário',
                                    labelStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                    hintText: 'Digite seu usuário...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins',
                                        fontSize: 12),
                                    suffixIcon: const Icon(Icons.email_rounded),
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
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor digite sua senha';
                                        }

                                        if (value.length < 4) {
                                          return 'A senha deve conter 4 caracteres';
                                        }
                                        return null;
                                      },
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          isDense: true,
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Senha',
                                          labelStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontFamily: 'Poppins',
                                              fontSize: 14),
                                          hintText: 'Digite sua senha...',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontFamily: 'Poppins',
                                              fontSize: 12),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          suffixIcon: Obx(() => IconButton(
                                                icon: Icon(controller
                                                        .isPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility),
                                                onPressed: () {
                                                  print(controller
                                                      .isPasswordVisible.value);
                                                  controller.isPasswordVisible
                                                          .value =
                                                      !controller
                                                          .isPasswordVisible
                                                          .value;
                                                },
                                              ))),
                                    )),
                                _gap(),
                                Obx(() => CheckboxListTile(
                                      value: controller.rememberMe.value,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        controller.rememberMe.value = value;
                                      },
                                      title: Text(
                                        'Salvar senha',
                                        style: CustomTextStyle.button2(context),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                    )),
                                _gap(),
                                SizedBox(
                                  width: double.infinity,
                                  child: Obx(
                                    () => Visibility(
                                      visible: !controller.loading.value,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.orange.shade500,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Acessar',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
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
                                Obx(() => Visibility(
                                    visible: controller.loading.value,
                                    child: Container(
                                      color: Colors.transparent,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        onPressed: null,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ))),
                                Obx(() {
                                  if (controller.showErrorSnackbar.value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Get.snackbar(
                                        'Erro de Autenticação',
                                        'Usuário ou senha inválidos',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      controller.showErrorSnackbar.value =
                                          false;
                                    });
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
