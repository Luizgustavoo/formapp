import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/screens/create_family.dart';
import 'package:formapp/app/screens/edit_family.dart';
import 'package:get/get.dart';

class FamilyView extends GetView<FamilyController> {
  final List<FamilyMember> familyMembersList = [];
  final TextEditingController _searchController = TextEditingController();

  FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> familias = [
      "Família Silva",
      "Família Fernandes",
      "Família Moura",
      "Família Tales",
      "Família Oliveira",
      "Família Vieira",
      "Família Farias",
      "Família Albert",
      "Família Nunes",
      "Família Coimbra",
      "Família Kimberly",
      "Família Krois",
      "Família Android",
      "Família Windows",
      "Família Linux",
      "Família Mac",
      "Família Google",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Famílias Cadastradas'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const CreateFamily())));
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: _searchController,
              onSearchPressed: (context, a, query) {}),
          Expanded(
            child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.listFamilies.length,
                  itemBuilder: (context, index) {
                    Family family = controller.listFamilies[index];

                    return CustomFamilyCard(
                        stripe: index % 2 == 0 ? true : false,
                        memberName: family.nome.toString(),
                        memberContact: 'Provedor: Nome do Provedor',
                        editMember: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const EditFamily())));
                        },
                        messageMember: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: MessageModal(
                                showWidget: false,
                              ),
                            ),
                          );
                        },
                        supportMember: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: MessageModal(
                                showWidget: true,
                              ),
                            ),
                          );
                        },
                        deleteMember: () {});
                  },
                )),
          )
        ],
      ),
    );
  }
}
