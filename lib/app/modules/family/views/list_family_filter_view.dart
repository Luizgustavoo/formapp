import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/widgets/create_family_modal.dart';
import 'package:ucif/app/global/widgets/custom_family_card.dart';
import 'package:ucif/app/global/widgets/message_modal.dart';
import 'package:ucif/app/global/widgets/message_service_modal.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/people/views/add_people_family_view.dart';

import 'package:ucif/app/modules/people/views/list_people_view.dart';
import 'package:ucif/app/modules/user/user_controller.dart';

import '../../../global/shimmer/shimmer_custom_family_card.dart';

class FamilyFilterView extends GetView<FamilyController> {
  FamilyFilterView({super.key});

  final PeopleController peopleController = Get.put(PeopleController());
  final UserController userController = Get.put(UserController());
  final messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/list-user',
                    arguments: userController.selectedUser);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              )),
          title: Column(
            children: [
              const Text(
                'Famílias',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Líder: ${controller.selectedUser?.nome}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          )),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15), topEnd: Radius.circular(15))),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getFamiliesFilter(controller.selectedUser!);
            // Get.offAllNamed('/filter-family');
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Obx(() => Row(
                      children: [
                        Flexible(
                          child: CustomCard(
                            title: 'Famílias',
                            description: controller.totalFamily.toString(),
                            imageUrl: 'assets/images/familia_icon.png',
                            showGenderInfo: false,
                            womanCount: '',
                            menCount: '',
                            noSexCount: '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: CustomCard(
                            title: 'Pessoas',
                            description: controller.totalPeoples.toString(),
                            imageUrl: 'assets/images/pessoa_icon.png',
                            womanCount: controller.totalFemale.toString(),
                            menCount: controller.totalMale.toString(),
                            noSexCount: controller.totalNoSex.toString(),
                            onTap: () {
                              peopleController.selectedUser =
                                  controller.selectedUser!;
                              peopleController
                                  .getPeoplesFilter(controller.selectedUser!);
                              Get.toNamed('/filter-people');
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadingFamiliesFiltered.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.9) {
                    controller.loadMoreFamiliesFiltered();
                  }
                  return false;
                },
                child: Obx(() {
                  final status = Get.find<InternetStatusProvider>().status;
                  final List<Family> familiesToShow =
                      controller.listFamilyPeoples;

                  if (controller.isLoadingFamilies.value) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller.scrollFilterFamily,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const CustomShimmerFamilyCard();
                      },
                    );
                  } else {
                    return AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: familiesToShow.length,
                        itemBuilder: (context, index) {
                          final Family family = familiesToShow[index];
                          String provedorCasa = "";

                          if (family.pessoas != null &&
                              family.pessoas!.isNotEmpty) {
                            for (var p in family.pessoas!) {
                              if (p.provedorCasa == 'sim') {
                                provedorCasa += p.nome!;
                              }
                            }
                          }

                          if (status == InternetStatus.disconnected &&
                              !family.familyLocal!) {
                            return ListView.builder(
                              controller: controller.scrollFilterFamily,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const CustomShimmerFamilyCard();
                              },
                            );
                          } else {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                curve: Curves.easeInOut,
                                child: FadeInAnimation(
                                  child: CustomFamilyCard(
                                    showMenu: false,
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
                                          padding:
                                              MediaQuery.of(context).viewInsets,
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
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: MessageModal(
                                            family: family,
                                            titulo: 'Mensagem para a Família',
                                          ),
                                        ),
                                      );
                                    },
                                    supportFamily: () {
                                      peopleController
                                          .clearModalMessageService();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        context: context,
                                        builder: (context) => Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: MessageServiceModal(
                                            family: family,
                                            showWidget: true,
                                            tipoOperacao: 'insert',
                                            titulo:
                                                'Atendimento ${family.nome}',
                                          ),
                                        ),
                                      );
                                    },
                                    addMember: () {
                                      peopleController
                                          .clearAllPeopleTextFields();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        context: context,
                                        builder: (context) => Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: AddPeopleFamilyView(
                                            peopleLocal: family.familyLocal!,
                                            tipoOperacao: 0,
                                            family: family,
                                          ),
                                        ),
                                      );
                                    },
                                    deleteFamily: () {
                                      Get.to(const ListPeopleView());
                                    },
                                    peopleNames: family.pessoas
                                        ?.map((person) => person.nome!)
                                        .toList(),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? womanCount;
  final String? menCount;
  final String? noSexCount;
  final bool showGenderInfo;
  final Function()? onTap;

  const CustomCard(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl,
      this.menCount,
      this.womanCount,
      this.noSexCount,
      this.showGenderInfo = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color(0xFF1C6399),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.height * 0.05,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showGenderInfo) // Exibir informações de gênero apenas se showGenderInfo for true
          Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
              color: Colors.blue.shade600,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/woman.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height * 0.030,
                            height: MediaQuery.of(context).size.height * 0.030,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            womanCount!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/men.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height * 0.030,
                            height: MediaQuery.of(context).size.height * 0.030,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            menCount!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/nosex.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height * 0.030,
                            height: MediaQuery.of(context).size.height * 0.030,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            noSexCount!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        if (!showGenderInfo) // Exibir o container específico se showGenderInfo for false
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 6),
            margin: const EdgeInsets.only(left: 5, right: 5, top: 0),
            color: Colors.blue.shade600,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.030,
                  height: MediaQuery.of(context).size.height * 0.030,
                )
              ],
            ),
          ),
      ],
    );
  }
}
