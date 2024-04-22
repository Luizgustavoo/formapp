import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_people_card.dart';
import 'package:ucif/app/global/widgets/custom_people_card.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

class PeopleFilterView extends GetView<PeopleController> {
  const PeopleFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              )),
          title: Column(
            children: [
              const Text(
                'Pessoas',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Líder: ${controller.selectedUser!.nome}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getPeoplesFilter(controller.selectedUser!);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(15),
              topEnd: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                    final status = Get.find<InternetStatusProvider>().status;

                    if (status == InternetStatus.disconnected) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return const ShimmerCustomPeopleCard();
                        },
                      );
                    } else {
                      if (controller.isLoading.value) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
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
                            itemCount: controller.listPeopleFamilies.length,
                            itemBuilder: (context, index) {
                              People people =
                                  controller.listPeopleFamilies[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  curve: Curves.easeInOut,
                                  child: FadeInAnimation(
                                    child: CustomPeopleCard(
                                      showMenu: false,
                                      people: people,
                                      stripe: index % 2 == 0 ? true : false,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
