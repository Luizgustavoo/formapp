import 'package:flutter/material.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class CreateUserView extends GetView<UserController> {
  const CreateUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.userFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Controle de Usuário",
                style: CustomTextStyle.title(context),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.orange.shade500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  return controller.validateName(value);
                },
                controller: controller.nameController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (value) {
                  return controller.validateLogin(value);
                },
                controller: controller.loginController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Login',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() => TextFormField(
                    validator: (value) {
                      return controller.validatePassword(value);
                    },
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
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
                            )),
                        labelText: 'Senha',
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'CANCELAR',
                        style: CustomTextStyle.button2(context),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        controller.saveUser();
                      },
                      child: Text(
                        'SALVAR',
                        style: CustomTextStyle.button(context),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
