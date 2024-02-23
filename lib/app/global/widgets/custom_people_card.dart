import 'package:flutter/material.dart';
import 'package:formapp/app/data/base_url.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomPeopleCard extends StatelessWidget {
  bool stripe = false;
  VoidCallback editFamily;
  VoidCallback deleteFamily;
  VoidCallback? addMember;
  VoidCallback? onEditPerson;
  VoidCallback? onDeletePerson;
  bool showAddMember = false;

  People people;

  CustomPeopleCard({
    Key? key,
    required this.editFamily,
    required this.deleteFamily,
    required this.people,
    this.addMember,
    required this.stripe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          print('arrastei');
          return false; // Retorna false para não remover o item
        },
        background: Container(
          color: Colors.orange.shade300,
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
                childrenPadding:
                    const EdgeInsets.only(left: 18, right: 18, bottom: 5),
                onExpansionChanged: (value) {
                  isExpanded.value = value;
                },
                title: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        // child: Text(
                        //   "P",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20),
                        // ),
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
                                    // peopleController.selectedPeople =
                                    //     family.pessoas![index];

                                    // peopleController.fillInFieldsForEditPerson();
                                    // showModalBottomSheet(
                                    //   isScrollControlled: true,
                                    //   isDismissible: false,
                                    //   context: context,
                                    //   builder: (context) => Padding(
                                    //     padding: MediaQuery.of(context).viewInsets,
                                    //     child: AddPeopleFamilyView(
                                    //       tipoOperacao: 1,
                                    //       family: family,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 22,
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: onDeletePerson,
                                //   icon: const Icon(
                                //     Icons.delete_outline,
                                //     size: 22,
                                //     color: Colors.red,
                                //   ),
                                // ),
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
