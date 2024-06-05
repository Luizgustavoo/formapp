import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_family_member_card.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

class FamilyMemberView extends GetView<PeopleController> {
  const FamilyMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: controller.isLoading == false &&
                          controller.listFamilyMembers.isEmpty
                      ? const Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Não há membros nesta família',
                            style:
                                TextStyle(fontFamily: 'Poppinss', fontSize: 22),
                          ),
                        )
                      : ListView.builder(
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
    );
  }
}
