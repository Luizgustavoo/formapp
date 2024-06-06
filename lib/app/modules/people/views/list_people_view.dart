import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_people_card.dart';
import 'package:ucif/app/global/widgets/create_family_modal.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_dynamic_rich_text.dart';
import 'package:ucif/app/global/widgets/custom_people_card.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/people/views/add_people_family_view.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ListPeopleView extends GetView<PeopleController> {
  const ListPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            showPadding: false,
            title: '',
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              controller.searchController.clear();
              Get.offAllNamed('/list-people');
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFf1f5ff),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 15),
                    SizedBox(
                      height: 35,
                      child: TextField(
                        controller: controller.searchController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (query) {
                          controller.getPeoples(
                              search: controller.searchController.text
                                  .toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Encontre um cadastrado ...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppinss',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.getPeoples(
                                  search: controller.searchController.text);
                            },
                            icon: const Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pessoas Cadastradas',
                      style: TextStyle(fontFamily: 'Poppinss', fontSize: 16),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 2,
                      color: Color(0xFF1C6399),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!controller.isLoading.value &&
                              scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent * 0.9) {
                            controller.loadMorePeoples();
                          }
                          return false;
                        },
                        child: Obx(() {
                          final status =
                              Get.find<InternetStatusProvider>().status;
                          final List<People> familiesToShow =
                              controller.listPeoples;

                          if (controller.isLoading.value) {
                            return ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: controller.scrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return const ShimmerCustomPeopleCard();
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
                                  final People people = familiesToShow[index];

                                  if (status == InternetStatus.disconnected &&
                                      !people.peopleLocal!) {
                                    return ListView.builder(
                                      controller: controller.scrollController,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: 15,
                                      itemBuilder: (context, index) {
                                        return const ShimmerCustomPeopleCard();
                                      },
                                    );
                                  } else {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        curve: Curves.easeInOut,
                                        child: FadeInAnimation(
                                          child: CustomPeopleCard(
                                            people: people,
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
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: UserStorage.getUserType() < 3
              ? SpeedDial(
                  childrenButtonSize: const Size(55, 55),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF014acb),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  isOpenOnStart: false,
                  animatedIcon: AnimatedIcons.menu_close,
                  buttonSize: const Size(50, 50),
                  children: [
                    SpeedDialChild(
                      backgroundColor: const Color(0xFF014acb),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      label: 'Adicionar Família',
                      labelStyle: const TextStyle(fontFamily: "Poppins"),
                      onTap: () {
                        final familyController = Get.put(FamilyController());
                        familyController.clearAllFamilyTextFields();
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
                    ),
                    SpeedDialChild(
                      backgroundColor: const Color(0xFF014acb),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      label: 'Adicionar Pessoas',
                      labelStyle: const TextStyle(fontFamily: "Poppins"),
                      onTap: () {
                        controller.getMaritalStatus();
                        controller.getChurch();
                        controller.getReligion();
                        controller.clearAllPeopleTextFields();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: const AddPeopleFamilyView(
                              peopleLocal: false,
                              tipoOperacao: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height -
                  CustomAppBar().preferredSize.height) *
              .180,
          left: 15,
          right: 15,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 15, bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DynamicRichText(
                          routeR: '/list-people',
                          value: homeController.counter2,
                          description: 'Pessoas',
                          valueStyle: const TextStyle(
                            fontFamily: 'Poppinss',
                          ),
                          descriptionStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          color: Colors.black,
                        ),
                        DynamicRichText(
                          routeR: '/list-family',
                          value: homeController.counter,
                          description: 'Famílias',
                          valueStyle: const TextStyle(
                            fontFamily: 'Poppinss',
                            height: 1,
                          ),
                          descriptionStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                          color: Colors.blue,
                        ),
                        DynamicRichText(
                          routeR: '/list-user',
                          value: homeController.counter3,
                          description: 'Lideranças',
                          valueStyle: const TextStyle(
                            fontFamily: 'Poppinss',
                            height: 1,
                          ),
                          descriptionStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
