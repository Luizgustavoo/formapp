import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/shimmer/shimmer_custom_people_card.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/global/widgets/custom_people_card.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class ListPeopleView extends GetView<PeopleController> {
  const ListPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15), topEnd: Radius.circular(15))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchWidget(
                controller: controller.searchController,
                onSearchPressed: (context, a, query) {
                  controller.searchPeople(query);
                }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5, // Número de itens de exemplo para o shimmer
                    itemBuilder: (context, index) {
                      return const ShimmerCustomPeopleCard();
                    },
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.listPeoples.length,
                    itemBuilder: (context, index) {
                      People people = controller.listPeoples[index];
                      return CustomPeopleCard(
                        people: people,
                        stripe: index % 2 == 0 ? true : false,
                      );
                    },
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
