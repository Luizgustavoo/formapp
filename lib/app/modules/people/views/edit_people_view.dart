import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_bottomsheet_file.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class EditPeopleView extends GetView<EditPeopleController> {
  const EditPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALTERAR FAMILIAR'),
      ),
      body: Form(
        key: controller.peopleFormKey,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //-------------->INFORMAÇÕES DO FAMILIAR<-------------------
                  ExpansionTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    initiallyExpanded: true,
                    title: const Text(
                      'Informações do Familiar',
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Divider(
                      height: 5,
                      thickness: 3,
                      color: Colors.orange.shade500,
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => CircleAvatar(
                                radius: 35,
                                backgroundImage: controller.isImagePicPathSet ==
                                        true
                                    ? FileImage(
                                            File(controller.photoUrlPath.value))
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/default_avatar.jpg'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    backgroundBlendMode: BlendMode.multiply,
                                    color: Colors.grey[300],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              CustomBottomSheet());
                                    },
                                  ),
                                ),
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Provedor da casa: ',
                            style: CustomTextStyle.form(context),
                          ),
                          Switch(
                            activeColor: Colors.orange.shade700,
                            inactiveThumbColor: Colors.orange.shade500,
                            inactiveTrackColor: Colors.orange.shade100,
                            value: controller.provedorCheckboxValue.value,
                            onChanged: (value) {
                              // setState(() {
                              //   provedorCheckboxValue = value;
                              //   familyMember.provedor =
                              //       provedorCheckboxValue ? 'Sim' : 'Não';
                              // });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: controller.nomePessoaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome Completo'),
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da rua';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.sexo!.value,
                              onChanged: (value) {},
                              items: [
                                'Masculino',
                                'Feminino'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Sexo'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.civil.value,
                              onChanged: (value) {},
                              items: [
                                'Solteiro(a)',
                                'Casado(a)',
                                'Divorciado(a)',
                                'Emancipado(a)'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Estado Civil'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Data de Nascimento'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'CPF'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Título de Eleitor'),
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Zona Eleitoral'),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.localTrabalhoPessoaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Trabalho'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.cargoPessoaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Cargo'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.celularPessoaController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Telefone'),
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: controller.redeSocialPessoaController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Rede Social'),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: controller.religiao.value,
                        onChanged: (value) {},
                        items: ['Católica', 'Evangélica', 'Outra']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Religião'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.igrejaPessoaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Igreja'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.funcaoIgrejaPessoaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Função/Igreja'),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 5,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green.shade800,
          child: const Icon(
            Icons.save_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
