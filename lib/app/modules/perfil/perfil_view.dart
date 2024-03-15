import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/modules/perfil/perfil_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class PerfilView extends GetView<PerfilController> {
  const PerfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showPadding: false,
      ),
      body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(15), topEnd: Radius.circular(15))),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: const AssetImage(
                          'assets/images/default_avatar.jpg'), // Imagem padrão
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () {
                                // Lógica para alterar a foto
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Nome',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Usuário',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Telefone',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Data de Nascimento',
                        labelStyle: CustomTextStyle.textFormFieldStyle(context),
                        fillColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para salvar
                        },
                        child: const Text(
                          'SALVAR',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppinss',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
