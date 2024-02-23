import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/message_service_modal.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomPeopleCard extends StatelessWidget {
  bool stripe = false;

  VoidCallback? addMember;
  VoidCallback? onEditPerson;
  VoidCallback? onDeletePerson;
  bool showAddMember = false;

  People people;

  CustomPeopleCard({
    Key? key,
    required this.people,
    this.addMember,
    required this.stripe,
  }) : super(key: key);

  final PeopleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          openFamilySelectionDialog();
          return false; // Retorna false para não remover o item
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orange.shade300,
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Alterar Família',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          color: (stripe ? Colors.grey.shade300 : Colors.white),
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
                      leading: CircleAvatar(
                        backgroundImage: people.foto.toString().isEmpty
                            ? const AssetImage(
                                'assets/images/default_avatar.jpg')
                            : NetworkImage(
                                    '$urlImagem/public/storage/${people.foto}')
                                as ImageProvider,
                      ),
                      title: Text(people.nome!,
                          style: CustomTextStyle.subtitleNegrit(context)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nascimento: ${people.dataNascimento!}",
                              style: CustomTextStyle.subtitle(context)),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  if (people.atendimentos!.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Atendimentos:",
                            style: CustomTextStyle.subtitleNegrit(context)),
                        Divider(
                          height: 3,
                          thickness: 2,
                          color: Colors.orange.shade300,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.atendimentos != null
                          ? people.atendimentos!.length
                          : 0,
                      itemBuilder: (context, index) {
                        FamilyService atendimento = people.atendimentos![index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              atendimento.assunto!,
                              overflow: TextOverflow.clip,
                              style: CustomTextStyle.subtitle(context),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.selectedService = atendimento;
                                    controller.fillInFieldsServicePerson();

                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      builder: (context) => Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: MessageServicePage(
                                          showWidget: true,
                                          // tipoOperacao: 'update',
                                          // titulo: 'Alteração do Atendimento',
                                          people: people,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ]
                ],
              )),
        ),
      ),
    );
  }
}

void openFamilySelectionDialog() {
  final FamilyController controller = Get.find();
  Get.dialog(
    AlertDialog(
      title: const Text('Selecionar Família'),
      content: SingleChildScrollView(
        child: Column(
          children: controller.listFamilies.map((family) {
            return CheckboxListTile(
              title: Text(family.nome!),
              value: controller.isSelected(family),
              onChanged: (bool? value) {
                controller.toggleFamilySelection(family);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.confirmFamilySelection();
            Get.back();
          },
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
