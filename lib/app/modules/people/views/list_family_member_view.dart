import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/create_family_modal.dart';

import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_family_member_card.dart';

import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

import 'package:ucif/app/utils/user_storage.dart';

class FamilyMemberView extends GetView<PeopleController> {
  FamilyMemberView({super.key});

  final PeopleController peopleController = Get.put(PeopleController());

  final messageController = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            showPadding: false,
            title: '',
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // controller.searchController.clear();
              // await controller.getFamilies();
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
                    SizedBox(height: MediaQuery.of(context).size.height / 18),

                    const SizedBox(height: 10),
                    const Text(
                      "Membros da família",
                      style: TextStyle(fontFamily: 'Poppinss', fontSize: 16),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 2,
                      color: Color(0xFF1C6399),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Expanded(
                        // child: NotificationListener<ScrollNotification>(
                        //   onNotification: (ScrollNotification scrollInfo) {
                        //     if (!controller.isLoadingFamilies.value &&
                        //         scrollInfo.metrics.pixels >=
                        //             scrollInfo.metrics.maxScrollExtent * 0.9) {
                        //       controller.loadMoreFamilies();
                        //     }
                        //     return false;
                        //   },
                        child: ListView.builder(
                          itemCount: controller.listFamilyMembers.length,
                          shrinkWrap: true,
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            People people = controller.listFamilyMembers[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 300),
                              child: SlideAnimation(
                                curve: Curves.easeInOut,
                                child: FadeInAnimation(
                                  child: CustomFamilyMemberCard(
                                    people: people,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: Get.height / 7,
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '35',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.black,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nPessoas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '9',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.blue,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nFamílias',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '23',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.green,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nLideranças',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
