import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/family_list_modal.dart';
import 'package:ucif/app/global/widgets/message_service_modal.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

// ignore: must_be_immutable
class CustomPeopleCard extends StatelessWidget {
  bool stripe = false;

  VoidCallback? addMember;
  VoidCallback? onEditPerson;
  bool showAddMember = false;
  final bool showMenu;

  People people;

  CustomPeopleCard(
      {Key? key,
      required this.people,
      this.addMember,
      required this.stripe,
      required this.showMenu})
      : super(key: key);

  final PeopleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final DateTime data = DateTime.parse('${people.dataNascimento}');
    final String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
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
          margin: const EdgeInsets.all(3),
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
                                    '$urlImagem/storage/app/public/${people.foto}')
                                as ImageProvider,
                      ),
                      title: Text(people.nome!.toUpperCase(),
                          style: CustomTextStyle.subtitleNegrit(context)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nascimento: $dataFormatada",
                              style: CustomTextStyle.subtitle(context)),
                          Text("Família: ${people.family!.nome}",
                              style: CustomTextStyle.subtitle(context)),
                          Text('Atendimentos: ${people.atendimentos!.length}',
                              style: CustomTextStyle.subtitle(context))
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  if (showMenu) ...[
                    Obx(() => isExpanded.value
                        ? const Divider(
                            height: 3,
                            thickness: 2,
                            color: Color(0xFF1C6399),
                          )
                        : const SizedBox()),
                    const SizedBox(height: 10),
                    people.atendimentos!.isEmpty
                        ? const Center(
                            child: Text(
                            'Não há atendimentos para essa pessoa',
                            style: TextStyle(
                                fontFamily: 'Poppinss', color: Colors.red),
                          ))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: people.atendimentos != null
                                ? people.atendimentos!.length
                                : 0,
                            itemBuilder: (context, index) {
                              FamilyService atendimento =
                                  people.atendimentos![index];

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          controller.selectedService =
                                              atendimento;
                                          controller
                                              .fillInFieldsServicePerson();

                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: MessageServiceModal(
                                                familyService: atendimento,
                                                showWidget: true,
                                                tipoOperacao: 'update',
                                                titulo:
                                                    'Alteração do Atendimento',
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
