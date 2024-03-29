import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/family_list_modal.dart';
import 'package:formapp/app/global/widgets/message_service_modal.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomPeopleCard extends StatelessWidget {
  bool stripe = false;

  VoidCallback? addMember;
  VoidCallback? onEditPerson;
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
    final familiaId = controller.box.read('auth')['user']['familia_id'];
    RxBool isExpanded = false.obs;

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Dismissible(
        key: UniqueKey(),
        direction: familiaId != null
            ? DismissDirection.none
            : DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            await showModalBottomSheet(
              context: context,
              builder: (context) => FamilyListModal(
                people: people,
              ),
            );
          }
          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orange.shade300,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    'Alterar Família',
                    style: CustomTextStyle.button(context),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.list_rounded, color: Colors.white)
                ],
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
                      title: Text(people.nome!.toUpperCase(),
                          style: CustomTextStyle.subtitleNegrit(context)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nascimento: ${people.dataNascimento!}",
                              style: CustomTextStyle.subtitle(context)),
                          Text("Família: ",
                              style: CustomTextStyle.subtitle(context))
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
                        Text(
                          "Atendimentos:",
                          style: CustomTextStyle.subtitleNegrit(context),
                        ),
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
                            Flexible(
                              child: Text(
                                atendimento.assunto!,
                                overflow: TextOverflow.clip,
                                style: CustomTextStyle.subtitle(context),
                              ),
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
                                        child: MessageServiceModal(
                                          familyService: atendimento,
                                          showWidget: true,
                                          tipoOperacao: 'update',
                                          titulo: 'Alteração do Atendimento',
                                          people: people,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: familiaId != null
                                      ? const Icon(
                                          Icons.search_outlined,
                                          size: 22,
                                        )
                                      : const Icon(
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
