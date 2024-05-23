import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_dynamic_rich_text.dart';
import 'package:ucif/app/global/widgets/custom_family_member_card.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

class FamilyMemberView extends GetView<PeopleController> {
  const FamilyMemberView({super.key});

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
          body: Container(
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
                    "Membros da Família",
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
                      child: ListView.builder(
                        itemCount: controller.listFamilyMembers.length,
                        shrinkWrap: true,
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
        Positioned(
          top: (MediaQuery.of(context).size.height -
                  CustomAppBar().preferredSize.height) *
              .17,
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
