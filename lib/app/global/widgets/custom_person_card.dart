import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
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
      this.showAddMember = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 3,
        color: stripe ? Colors.grey.shade300 : Colors.white,
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
                    leading: CircleAvatar(
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
                        Text("${family.pessoas!.length} Moradores Cadastrados",
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
                  itemCount: family.pessoas!.length,
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
                                // Altere isso conforme necessário
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
                                      tipo_operacao: 1,
                                      family: family,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 22,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: onDeletePerson,
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 22,
                                color: Colors.red,
                              ),
                            ),
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
