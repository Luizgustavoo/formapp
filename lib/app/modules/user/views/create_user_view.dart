import 'package:flutter/material.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class CreateUserView extends GetView<UserController> {
  const CreateUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                child: Text(
                  'Informações do Usuário',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Divider(
                height: 5,
                thickness: 3,
                color: Colors.orange.shade500,
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Login',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.lock),
                    labelText: 'Senha',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'CANCELAR',
                        style: CustomTextStyle.button2(context),
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'SALVAR',
                        style: CustomTextStyle.button(context),
                      )),
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}
