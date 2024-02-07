import 'package:flutter/material.dart';
import 'package:formapp/app/modules/family/family_controller.dart';

import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class AddPeopleFamilyView extends GetView<FamilyController> {
  const AddPeopleFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adicionar Pessoa',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: controller.photoUrl.value.isNotEmpty
                            ? NetworkImage(controller.photoUrl.value)
                            : const AssetImage(
                                    'assets/images/default_avatar.jpg')
                                as ImageProvider,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            backgroundBlendMode: BlendMode.multiply,
                            color: Colors.grey[300],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Provedor da casa: ',
                        style: TextStyle(),
                      ),
                      Switch(
                        activeColor: Colors.orange.shade700,
                        inactiveThumbColor: Colors.orange.shade500,
                        inactiveTrackColor: Colors.orange.shade100,
                        value: controller.provedorCheckboxValue.value,
                        onChanged: (value) {
                          controller.provedorCheckboxValue.value = value;
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
                        return 'Por favor, digite o nome do morador';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: controller.sexo.value,
                          onChanged: (value) {},
                          items: ['Masculino', 'Feminino']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Sexo'),
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
                    controller: controller.nascimentoPessoaController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Data de Nascimento'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.cpfPessoaController,
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
                          controller:
                              controller.tituloEleitoralPessoaController,
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
                          controller: controller.zonaEleitoralPessoaController,
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
                        border: OutlineInputBorder(), labelText: 'Trabalho'),
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
                    onChanged: (value) {
                      controller.religiao.value = value!;
                    },
                    items: ['Católica', 'Evangélica', 'Outra']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Religião'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
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
                  const SizedBox(
                    height: 8,
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
                            if (controller.formKey.currentState!.validate()) {
                              controller.addPessoa();
                              controller.familyInfo.value = false;
                              Get.back();
                            }
                          },
                          child: Text(
                            'ADICIONAR',
                            style: CustomTextStyle.button(context),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
