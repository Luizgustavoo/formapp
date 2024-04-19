import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/global/widgets/message_service_modal.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/people/views/add_people_family_view.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

// ignore: must_be_immutable
class CustomFamilyCard extends StatelessWidget {
  bool stripe = false;
  String familyName;
  String provedor;
  VoidCallback editFamily;
  VoidCallback messageMember;
  VoidCallback supportFamily;
  VoidCallback deleteFamily;
  VoidCallback? addMember;
  VoidCallback? onEditPerson;
  VoidCallback? onDeletePerson;
  bool showAddMember = false;
  bool local = false;
  List<String>? peopleNames;
  FamilyController familyController = Get.find();
  PeopleController peopleController = Get.find();
  Family family;
  final messageController = Get.find<MessageController>();
  final bool showMenu;

  final int? index;

  CustomFamilyCard(
      {Key? key,
      this.familyName = '',
      this.provedor = '',
      required this.editFamily,
      required this.messageMember,
      required this.supportFamily,
      required this.deleteFamily,
      required this.family,
      this.addMember,
      required this.stripe,
      required this.index,
      this.peopleNames,
      this.local = false,
      required this.showMenu,
      this.showAddMember = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 3,
        color: local
            ? Colors.red.shade400
            : (stripe ? Colors.grey.shade300 : Colors.white),
        child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ExpansionTile(
              trailing: showMenu
                  ? PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          value: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 160, 206, 241),
                                onTap: editFamily,
                                child: const ListTile(
                                  splashColor: Colors.transparent,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  hoverColor: Colors.transparent,
                                  leading: Icon(Icons.edit_outlined,
                                      color: Color(0xFF1C6399)),
                                  title: Text('Editar',
                                      style: TextStyle(fontFamily: 'Poppinss')),
                                ),
                              ),
                              if (UserStorage.getUserType() < 3) ...[
                                if (!local) ...[
                                  InkWell(
                                    onTap: () async {
                                      peopleController
                                          .clearModalMessageService();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        context: context,
                                        builder: (context) => Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: MessageServiceModal(
                                            family: family,
                                            showWidget: true,
                                            titulo:
                                                'Atendimento ${family.nome}',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const ListTile(
                                      splashColor: Colors.transparent,
                                      contentPadding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      hoverColor: Colors.transparent,
                                      leading: Icon(Icons.support_agent_rounded,
                                          color: Color(0xFF1C6399)),
                                      title: Text('Atendimento',
                                          style: TextStyle(
                                              fontFamily: 'Poppinss')),
                                    ),
                                  ),
                                ],
                                if (showAddMember)
                                  InkWell(
                                    onTap: addMember,
                                    child: const ListTile(
                                      splashColor: Colors.transparent,
                                      contentPadding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      hoverColor: Colors.transparent,
                                      leading: Icon(Icons.add_rounded,
                                          color: Color(0xFF1C6399)),
                                      title: Text('Adicionar',
                                          style: TextStyle(
                                              fontFamily: 'Poppinss')),
                                    ),
                                  ),
                                InkWell(
                                  onTap: () {
                                    showDialog(context, family);
                                  },
                                  child: const ListTile(
                                    splashColor: Colors.transparent,
                                    contentPadding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    hoverColor: Colors.transparent,
                                    leading: Icon(Icons.delete_outlined,
                                        color: Color(0xFF1C6399)),
                                    title: Text('Excluir',
                                        style:
                                            TextStyle(fontFamily: 'Poppinss')),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              childrenPadding:
                  const EdgeInsets.only(left: 18, right: 18, bottom: 5),
              onExpansionChanged: (value) {
                isExpanded.value = value;
              },
              title: Column(
                children: [
                  ListTile(
                    leading: (local && family.pessoas!.isNotEmpty)
                        ? IconButton(
                            onPressed: () async {
                              if (await ConnectionStatus.verifyConnection()) {
                                Map<String, dynamic> retorno =
                                    await familyController
                                        .sendFamilyToAPI(family);

                                //Get.back();

                                Get.snackbar(
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(milliseconds: 1500),
                                  retorno['return'] == 0 ? 'Sucesso' : "Falha",
                                  retorno['message'],
                                  backgroundColor: retorno['return'] == 0
                                      ? Colors.green
                                      : Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(milliseconds: 1500),
                                  "Sem conexão",
                                  "Verifique sua conexão com a internet!",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                              size: 32,
                              color: Colors.white,
                            ))
                        : CircleAvatar(
                            child: Text(
                              family.nome![0].toUpperCase().toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                    title: Text(familyName,
                        style: CustomTextStyle.subtitleNegrit(context)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Credenciado: ${family.user != null ? family.user!.nome! : ""}",
                            style: CustomTextStyle.form(context)),
                        Text(provedor, style: CustomTextStyle.form(context)),
                        Text(
                            "${family.pessoas != null ? family.pessoas!.length : 0} Moradores Cadastrados",
                            style: CustomTextStyle.form(context)),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                Obx(() => isExpanded.value
                    ? const Divider(
                        height: 3,
                        thickness: 2,
                        color: Color(0xFF1C6399),
                      )
                    : const SizedBox()),
                const SizedBox(height: 10),
                family.pessoas!.isEmpty
                    ? const Center(
                        child: Text(
                        'Não há pessoas cadastradas na família',
                        style: TextStyle(
                            fontFamily: 'Poppinss', color: Colors.red),
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            family.pessoas != null ? family.pessoas!.length : 0,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  showMenu
                                      ? PopupMenuButton<int>(
                                          iconColor: const Color(0xFF1C6399),
                                          onSelected: (value) {
                                            switch (value) {
                                              case 0: // Edit option
                                                peopleController
                                                        .selectedPeople =
                                                    family.pessoas![index];
                                                peopleController
                                                    .fillInFieldsForEditPerson();
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  isDismissible: false,
                                                  context: context,
                                                  builder: (context) => Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: AddPeopleFamilyView(
                                                      peopleLocal:
                                                          family.familyLocal!,
                                                      tipoOperacao: 1,
                                                      family: family,
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case 1: // Support option
                                                peopleController
                                                    .clearModalMessageService();
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  isDismissible: false,
                                                  context: context,
                                                  builder: (context) => Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: MessageServiceModal(
                                                      people: family
                                                          .pessoas![index],
                                                      showWidget: true,
                                                      titulo: 'Atendimento',
                                                    ),
                                                  ),
                                                );
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<int>>[
                                                const PopupMenuItem<int>(
                                                  value: 0,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.edit_outlined),
                                                    title: Text('Editar'),
                                                  ),
                                                ),
                                                if (UserStorage.getUserType() <
                                                        3 &&
                                                    !local)
                                                  const PopupMenuItem<int>(
                                                    value: 1,
                                                    child: ListTile(
                                                      leading: Icon(Icons
                                                          .support_agent_rounded),
                                                      title:
                                                          Text('Atendimento'),
                                                    ),
                                                  ),
                                              ])
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.people,
                                            color: Color(0xFF1C6399),
                                          ),
                                        )
                                ],
                              ),
                              Flexible(
                                child: Text(
                                  family.pessoas![index].nome!,
                                  overflow: TextOverflow.clip,
                                  style: CustomTextStyle.subtitle(context),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            )),
      ),
    );
  }

  void showDialog(context, Family family) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      titleStyle: CustomTextStyle.titleSplash(context),
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja remover a ${family.nome} ?",
        style: const TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancelar",
            style: CustomTextStyle.button2(context),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await familyController.deleteFamily(family.id!, local);

            if (retorno['return'] == 0) {
              Get.back();
            }
            Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(milliseconds: 1500),
              retorno['return'] == 0 ? 'Sucesso' : "Falha",
              retorno['message'],
              backgroundColor:
                  retorno['return'] == 0 ? Colors.green : Colors.red,
              colorText: Colors.white,
            );
          },
          child: Text(
            "Confirmar",
            style: CustomTextStyle.button(context),
          ),
        ),
      ],
    );
  }
}
