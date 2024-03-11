import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/internet_status_provider.dart';
import 'package:formapp/app/global/widgets/create_family_modal.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/message_service_modal.dart';
import 'package:formapp/app/global/widgets/show_case.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/modules/people/views/list_people_view.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';

import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/global/widgets/custom_family_card.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/views/add_people_family_view.dart';

import '../../../global/shimmer/shimmer_custom_family_card.dart';

class FamilyView extends GetView<FamilyController> {
  FamilyView({super.key});

  final PeopleController peopleController = Get.put(PeopleController());
  final UserController userController = Get.put(UserController());
  final messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    final familiaId = peopleController.box.read('auth')['user']['familia_id'];
    userController.getUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Famílias Cadastradas'),
        actions: [
          if (familiaId == null) ...[
            IconButton(
              onPressed: () {
                controller.clearAllFamilyTextFields();
                controller.typeOperation.value = 1;
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  context: context,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: CreateFamilyModal(
                      tipoOperacao: 'insert',
                      titulo: "Cadastro de Família",
                    ),
                  ),
                );
              },
              icon: ShowCaseView(
                title: 'ADICONAR FAMÍLIA',
                description: 'Adicione famílias.',
                border: const CircleBorder(),
                globalKey: controller.addFamily,
                child: const Icon(Icons.add_rounded),
              ),
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          if (UserStorage.getUserType() == 1)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: SizedBox(
                height: 40, // Defina a altura desejada aqui
                child: Obx(
                  () => ListView.builder(
                    itemCount: userController.listUsers.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () {
                            String idClicado =
                                userController.listUsers[index].id.toString();

                            controller.searchFamilyUserId(idClicado);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // Cor de fundo transparente
                            elevation: 0, // Remove a elevação padrão
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // Borda circular
                              side: const BorderSide(
                                  width: 1.2,
                                  color: Colors
                                      .orange), // Espessura da borda e cor laranja
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              userController.listUsers[index].nome!,
                              style: TextStyle(
                                  color: Colors
                                      .orange.shade500), // Cor do texto laranja
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          SearchWidget(
              controller: controller.searchController,
              onSearchPressed: (context, a, query) {
                controller.searchFamily(query);
              }),
          Expanded(
            child: Obx(() {
              final status = Get.find<InternetStatusProvider>().status;

              // return CustomFamilyCard(
              //   index: 0,
              //   local: false,
              //   family: Family(
              //       nome: "Nome da família",
              //       user: User(nome: "Nome do Credenciado")),
              //   showAddMember: true,
              //   stripe: true,
              //   familyName: "Nome da família",
              //   provedor: "Provedor: Nome do Provedor",
              //   editFamily: () {},
              //   messageMember: () {},
              //   supportFamily: () {},
              //   addMember: null,
              //   deleteFamily: () {},
              //   peopleNames: const ['Pessoa 01', 'Pessoa 02'],
              // );

              final List<Family> familiesToShow = controller.listFamilies;

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: familiesToShow.length,
                itemBuilder: (context, index) {
                  final Family family = familiesToShow[index];
                  String provedorCasa = "";

                  if (family.pessoas != null && family.pessoas!.isNotEmpty) {
                    for (var p in family.pessoas!) {
                      if (p.provedorCasa == 'sim') {
                        provedorCasa += p.nome!;
                      }
                    }
                  }

                  if (status == InternetStatus.disconnected &&
                      !family.familyLocal!) {
                    return const ShimmerCustomFamilyCard();
                  } else {
                    return CustomFamilyCard(
                      index: index,
                      local: family.familyLocal!,
                      family: family,
                      showAddMember: true,
                      stripe: index % 2 == 0 ? true : false,
                      familyName: family.nome.toString(),
                      provedor: "Provedor: $provedorCasa",
                      editFamily: () {
                        controller.selectedFamily = family;

                        controller.fillInFields();

                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: CreateFamilyModal(
                              tipoOperacao: 'update',
                              titulo: 'Alteração da Família',
                              family: family,
                            ),
                          ),
                        );
                      },
                      messageMember: () {
                        messageController.clearModalMessage();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: MessageModal(
                              family: family,
                              titulo: 'Mensagem para a Família',
                            ),
                          ),
                        );
                      },
                      supportFamily: () {
                        peopleController.clearModalMessageService();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: MessageServiceModal(
                              family: family,
                              showWidget: true,
                              tipoOperacao: 'insert',
                              titulo: 'Atendimento ${family.nome}',
                            ),
                          ),
                        );
                      },
                      addMember: () {
                        peopleController.clearAllPeopleTextFields();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: AddPeopleFamilyView(
                              tipoOperacao: 0,
                              family: family,
                            ),
                          ),
                        );
                      },
                      deleteFamily: () {
                        Get.to(const ListPeopleView());
                      },
                      peopleNames: family.pessoas != null
                          ? family.pessoas!
                              .map((person) => person.nome!)
                              .toList()
                          : null,
                    );
                  }
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
