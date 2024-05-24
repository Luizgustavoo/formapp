import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/widgets/create_family_modal.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_family_card.dart';
import 'package:ucif/app/global/widgets/search_widget.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

import 'package:ucif/app/utils/user_storage.dart';

import '../../../global/shimmer/shimmer_custom_family_card.dart';

class FamilyViewbckp extends GetView<FamilyController> {
  FamilyViewbckp({super.key});

  final PeopleController peopleController = Get.put(PeopleController());

  final messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: 'Famílias',
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15), topEnd: Radius.circular(15))),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.searchController.clear();
            Get.offAllNamed('/list-family');
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchWidget(
                controller: controller.searchController,
                onSearchPressed: (context, a, query) {
                  controller.getFamilies(
                      search: controller.searchController.text);
                },
                onSubmitted: (context, a, query) {
                  controller.getFamilies(
                      search: controller.searchController.text);
                },
                isLoading: controller.isLoadingFamilies.value,
              ),
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadingFamilies.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.9) {
                    controller.loadMoreFamilies();
                  }
                  return false;
                },
                child: Obx(() {
                  final status = Get.find<InternetStatusProvider>().status;
                  final List<Family> familiesToShow = controller.listFamilies;

                  if (controller.isLoadingFamilies.value) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller.scrollController,
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

                          if (status == InternetStatus.disconnected &&
                              !family.familyLocal!) {
                            return ListView.builder(
                              controller: controller.scrollController,
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
                                    family: family,
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
      floatingActionButton: UserStorage.getUserType() < 3
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1C6399),
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
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}
