import 'package:flutter/material.dart';
import 'package:formapp/app/modules/login/login_controller.dart';
import 'package:get/get.dart';

class LoginModal extends StatelessWidget {
  LoginModal({super.key});

  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        height: size.height * .30,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Faça login novamente'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.usernameCtrl,
                  validator: (value) {
                    return controller.validateUsername(value);
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
                    suffixIcon:
                        const Icon(Icons.email_rounded, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.passwordCtrl,
                  validator: (value) {
                    return controller.validatePassword(value);
                  },
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
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
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: Obx(() => IconButton(
                            icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54),
                            onPressed: () {
                              controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                            },
                          ))),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => Visibility(
                      visible: !controller.loading.value,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade500,
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
                Obx(
                  () => Visibility(
                    visible: controller.loading.value,
                    child: Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.symmetric(vertical: 10),
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
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
