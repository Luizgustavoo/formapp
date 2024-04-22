import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_people_card.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_people_card.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

class ListPeopleView extends GetView<PeopleController> {
  const ListPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: 'Pessoas',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.searchController.clear();
          await controller.getPeoples();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextField(
                  controller: controller.searchController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (query) {
                    controller.getPeoples(
                        search: controller.searchController.text);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Digite um nome...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppinss',
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.getPeoples(
                            search: controller.searchController.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color(0xFF1C6399),
                      ),
                    ),
                  ),
                ),
              ),
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
                        itemCount: 8,
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
                          itemCount: 8,
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
                            itemCount: controller.listPeoples.length,
                            itemBuilder: (context, index) {
                              People people = controller.listPeoples[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  curve: Curves.easeInOut,
                                  child: FadeInAnimation(
                                    child: CustomPeopleCard(
                                      showMenu: true,
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
