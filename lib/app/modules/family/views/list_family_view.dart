import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:get/get.dart';

class FamilyView extends GetView<FamilyController> {
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Famílias Cadastradas'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed('/create-family');
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: controller.searchController,
              onSearchPressed: (context, a, query) {}),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.listFamilies.length,
                itemBuilder: (context, index) {
                  Family family = controller.listFamilies[index];

                  String? provedorCasa = "";

                  for (var p in family.pessoas!) {
                    provedorCasa = (p.provedor_casa == 'sim') ? p.nome : "";
                  }

                  return CustomFamilyCard(
                    stripe: index % 2 == 0 ? true : false,
                    memberName: family.nome.toString(),
                    memberContact: "Provedor: $provedorCasa",
                    editMember: () {
                      // controller.nomeFamiliaController.text =
                      //     family.nome.toString();
                      // controller.cepFamiliaController.text =
                      //     family.cep.toString();

                      controller.selectedFamily = family;

                      controller.popularCampos();

                      Get.toNamed('/edit-family', arguments: family);
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
                    deleteMember: () {},
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}