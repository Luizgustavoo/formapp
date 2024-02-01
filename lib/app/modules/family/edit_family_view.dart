import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/modules/family/family_edit_controller.dart';
import 'package:formapp/app/screens/edit_person.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class EditFamilyView extends GetView<FamilyEditController> {
  final List<FamilyMember> familyMembersList = [];

  int editedFamilyMemberIndex = -1;

  EditFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: controller.tabIndex.value,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle de Família'),
          bottom: TabBar(
            controller: controller.tabController,
            labelStyle: CustomTextStyle.button2(context),
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Família'),
              Tab(text: 'Composição Familiar'),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: [
            Form(
              key: controller.familyFormKey,
              child: ListView(
                padding: const EdgeInsets.all(12.0),
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
                        controller: controller.nomeFamiliaController,
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
                          Text(
                            'Residência Própria: ',
                            style: CustomTextStyle.form(context),
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
                ],
              ),
            ),

            Container()
            // //DADOS DA COMPOSIÇÃO FAMILIAR
            // Form(
            //   key: controller.individualFormKey,
            //   child: Card(
            //     child: Expanded(
            //       child: ListView.builder(
            //         itemCount: 20,
            //         itemBuilder: (context, index) {
            //           return CustomFamilyCard(
            //               stripe: index % 2 == 0 ? true : false,
            //               memberName: 'Luiz',
            //               memberContact: '43 99928-9380',
            //               editMember: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: ((context) =>
            //                             const EditPerson())));
            //               },
            //               messageMember: () {
            //                 showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   context: context,
            //                   builder: (context) => Padding(
            //                     padding: MediaQuery.of(context).viewInsets,
            //                     child: MessageModal(
            //                       showWidget: false,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               supportMember: () {
            //                 showModalBottomSheet(
            //                   isScrollControlled: true,
            //                   context: context,
            //                   builder: (context) => Padding(
            //                     padding: MediaQuery.of(context).viewInsets,
            //                     child: MessageModal(
            //                       showWidget: true,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               deleteMember: () {});
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            elevation: 5,
            onPressed: () {
              if (controller.tabIndex.value == 0) {
                print('Adicionar novo membro à Composição Familiar');
              } else if (controller.tabIndex.value == 1) {
                print('Salvar informações da Família');
              }
            },
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
      ),
    );
  }
}
