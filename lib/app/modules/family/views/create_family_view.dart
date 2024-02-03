import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/family/views/add_people_family_view.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class CreateFamilyView extends GetView<FamilyController> {
  const CreateFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: controller.tabIndex.value,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Controle de Família'),
          ),
          body: _buildFamilyForm(),
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                elevation: 5,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: const AddPeopleFamilyView(),
                    ),
                  );

                  // if (controller.tabController!.index == 0) {
                  //   controller.addPessoa();
                  //   print('Adicionar novo membro à Composição Familiar');
                  // } else if (controller.tabController!.index == 1) {
                  //   print('Salvar informações da Família');
                  // }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: controller.tabController!.index == 1
                    ? Colors.green.shade800
                    : Colors.orange.shade700,
                child: Icon(
                  controller.tabController!.index == 1
                      ? Icons.save_outlined
                      : Icons.add,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildFamilyForm() {
    return Form(
      key: controller.familyFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              key: GlobalKey(),
              initiallyExpanded: controller.familyInfo.value,
              onExpansionChanged: (value) {
                controller.familyInfo.value = value;
              },
              title: const Text(
                'Informações da Família',
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome da Família',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome da família';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        splashRadius: 2,
                        iconSize: 20,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_rounded,
                        )),
                    labelText: 'CEP',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome da rua';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Logradouro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome da rua';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da rua';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nº',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o número da rua';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o número da rua';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da rua';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'UF',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o número da rua';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Residência Própria: ',
                      style: TextStyle(),
                    ),
                    Switch(
                      activeColor: Colors.orange.shade700,
                      inactiveThumbColor: Colors.orange.shade500,
                      inactiveTrackColor: Colors.orange.shade100,
                      value: controller.residenceOwn.value,
                      onChanged: (value) {
                        controller.residenceOwn.value = value;
                      },
                    ),
                  ],
                ),
              ],
            ),
            ExpansionTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              key: GlobalKey(),
              initiallyExpanded: controller.familyInfo.value,
              onExpansionChanged: (value) {
                controller.familyInfo.value = value;
              },
              title: const Text(
                'Informações da Família',
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
              children: const [],
            )
          ],
        ),
      ),
    );
  }

  Widget _familyComposition() {
    return Form(
      key: controller.individualFormKey,
      child: ListView.builder(
        itemCount: controller.composicaoFamiliar.length,
        itemBuilder: (context, index) {
          Pessoas pessoa = controller.composicaoFamiliar[index];
          return Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Card(
              elevation: 3,
              color: index % 2 == 0
                  ? const Color.fromRGBO(224, 224, 224, 1)
                  : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExpansionTile(
                    leading: const CircleAvatar(
                      child: Text(
                        "N",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    title: Text(pessoa.nome!),
                    subtitle: const Text('Nascimento: 10/05/1988'),
                    children: const [
                      Column(
                        children: [Text("CPF: 081.360.536-87")],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
