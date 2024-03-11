import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/message_service_modal.dart';
import 'package:formapp/app/global/widgets/show_case.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/people/views/add_people_family_view.dart';
import 'package:formapp/app/modules/people/people_controller.dart';

import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

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
      this.showAddMember = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;
    final familiaId = familyController.box.read('auth')['user']['familia_id'];
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
                    leading: local
                        ? IconButton(
                            onPressed: () async {
                              Map<String, dynamic> retorno =
                                  await familyController
                                      .sendFamilyToAPI(family);

                              Get.back();

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
                  Divider(
                    height: 3,
                    thickness: 2,
                    color: Colors.orange.shade300,
                  ),
                  Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!isExpanded.value) ...[
                              index == 0
                                  ? ShowCaseView(
                                      border: const CircleBorder(),
                                      description:
                                          'Aqui você pode editar as informações da família.',
                                      globalKey: familyController.editFamily,
                                      title: 'EDIÇÃO',
                                      child: IconButton(
                                        iconSize: 22,
                                        onPressed: editFamily,
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                    )
                                  : IconButton(
                                      iconSize: 22,
                                      onPressed: editFamily,
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                              if (familiaId == null) ...[
                                index == 0
                                    ? ShowCaseView(
                                        title: 'MENSAGEM',
                                        description:
                                            'Aqui você pode mandar mensagem para todos os integrantes da família.',
                                        border: const CircleBorder(),
                                        globalKey:
                                            familyController.messageFamily,
                                        child: IconButton(
                                          iconSize: 22,
                                          onPressed: messageMember,
                                          icon:
                                              const Icon(Icons.email_outlined),
                                        ),
                                      )
                                    : IconButton(
                                        iconSize: 22,
                                        onPressed: messageMember,
                                        icon: const Icon(Icons.email_outlined),
                                      ),
                                index == 0
                                    ? ShowCaseView(
                                        title: 'ATENDIMENTO',
                                        description:
                                            'Aqui você pode realizar atendimento para a família.',
                                        border: const CircleBorder(),
                                        globalKey:
                                            familyController.supportFamily,
                                        child: IconButton(
                                          iconSize: 22,
                                          onPressed: () async {
                                            peopleController
                                                .clearModalMessageService();
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              isDismissible: false,
                                              context: context,
                                              builder: (context) => Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                child: MessageServiceModal(
                                                  family: family,
                                                  showWidget: true,
                                                  titulo:
                                                      'Atendimento ${family.nome}',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.support_agent_rounded),
                                        ),
                                      )
                                    : IconButton(
                                        iconSize: 22,
                                        onPressed: () async {
                                          peopleController
                                              .clearModalMessageService();
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: MessageServiceModal(
                                                family: family,
                                                showWidget: true,
                                                titulo:
                                                    'Atendimento ${family.nome}',
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.support_agent_rounded),
                                      ),
                                if (showAddMember)
                                  index == 0
                                      ? ShowCaseView(
                                          title: 'ADICIONAR',
                                          description:
                                              'Aqui você pode adicionar membros à família.',
                                          border: const CircleBorder(),
                                          globalKey: familyController.addMember,
                                          child: IconButton(
                                            iconSize: 22,
                                            onPressed: addMember,
                                            icon: const Icon(Icons.add_rounded),
                                          ),
                                        )
                                      : IconButton(
                                          iconSize: 22,
                                          onPressed: addMember,
                                          icon: const Icon(Icons.add_rounded),
                                        ),
                                index == 0
                                    ? ShowCaseView(
                                        title: 'EXCLUIR',
                                        description:
                                            'Aqui você poderá excluir os dados da família, lembrando que você perderá todos os dados que já cadastrou.',
                                        border: const CircleBorder(),
                                        globalKey:
                                            familyController.disableFamily,
                                        child: IconButton(
                                          iconSize: 22,
                                          onPressed: () {
                                            showDialog(context, family);
                                          },
                                          icon:
                                              const Icon(Icons.delete_outlined),
                                        ),
                                      )
                                    : IconButton(
                                        iconSize: 22,
                                        onPressed: () {
                                          showDialog(context, family);
                                        },
                                        icon: const Icon(Icons.delete_outlined),
                                      ),
                              ]
                            ]
                          ]))
                ],
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      family.pessoas != null ? family.pessoas!.length : 0,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            family.pessoas![index].nome!,
                            overflow: TextOverflow.clip,
                            style: CustomTextStyle.subtitle(context),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                peopleController.selectedPeople =
                                    family.pessoas![index];

                                peopleController.fillInFieldsForEditPerson();
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: AddPeopleFamilyView(
                                      tipoOperacao: 1,
                                      family: family,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 22,
                              ),
                            ),
                            if (familiaId == null) ...[
                              IconButton(
                                iconSize: 22,
                                onPressed: () {
                                  peopleController.clearModalMessageService();
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: MessageServiceModal(
                                        people: family.pessoas![index],
                                        showWidget: true,
                                        titulo:
                                            'Atendimento ${peopleNames![index]}',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.support_agent_rounded),
                              ),
                              IconButton(
                                iconSize: 22,
                                onPressed: () {
                                  List<People> listPeople = [];
                                  listPeople.add(family.pessoas![index]);
                                  final family2 = Family(
                                    pessoas: listPeople,
                                  );
                                  messageController.clearModalMessage();
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: MessageModal(
                                        family: family2,
                                        titulo:
                                            'Mensagem para a Pessoa ${family.pessoas![index].nome}',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.email_outlined),
                              )
                            ]
                          ],
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
                await familyController.deleteFamily(family.id!);

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
