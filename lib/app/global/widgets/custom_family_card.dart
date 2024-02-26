import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/global/widgets/message_service_modal.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/family/views/add_people_family_view.dart';
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
      this.peopleNames,
      this.local = false,
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
                        Text(provedor,
                            style: CustomTextStyle.subtitle(context)),
                        Text(
                            "${family.pessoas != null ? family.pessoas!.length : 0} Moradores Cadastrados",
                            style: CustomTextStyle.subtitle(context)),
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
                              IconButton(
                                iconSize: 22,
                                onPressed: editFamily,
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                iconSize: 22,
                                onPressed: messageMember,
                                icon: const Icon(Icons.email_outlined),
                              ),
                              IconButton(
                                iconSize: 22,
                                onPressed: supportFamily,
                                icon: const Icon(Icons.support_agent_rounded),
                              ),
                              if (showAddMember)
                                IconButton(
                                  iconSize: 22,
                                  onPressed: addMember,
                                  icon: const Icon(Icons.add_rounded),
                                ),
                              IconButton(
                                iconSize: 22,
                                onPressed: deleteFamily,
                                icon: const Icon(Icons.delete_outlined),
                              ),
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
                        Text(
                          family.pessoas![index].nome!,
                          overflow: TextOverflow.clip,
                          style: CustomTextStyle.subtitle(context),
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
                            IconButton(
                              iconSize: 22,
                              onPressed: () {
                                peopleController.clearModalMessageService();
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: MessageServicePage(
                                      people: family.pessoas![index],
                                      showWidget: true,
                                      titulo: '',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.support_agent_rounded),
                            ),
                            IconButton(
                              iconSize: 22,
                              onPressed: messageMember,
                              icon: const Icon(Icons.email_outlined),
                            )
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
}
