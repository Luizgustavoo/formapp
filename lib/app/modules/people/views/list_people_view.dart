import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/global/widgets/custom_people_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class ListPeopleView extends GetView<PeopleController> {
  const ListPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas Cadastradas'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed('/create-family');
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: controller.searchController,
              onSearchPressed: (context, a, query) {
                controller.searchPeople(query);
              }),
          Expanded(
            child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.listPeoples.length,
                  itemBuilder: (context, index) {
                    People people = controller.listPeoples[index];

                    return CustomPeopleCard(
                        people: people,
                        stripe: index % 2 == 0 ? true : false,
                        editFamily: () {
                          // controller.selectedFamily = family;
                          // controller.fillInFields();

                          // Get.toNamed('/edit-family', arguments: family);
                        },
                        addMember: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: MessageModal(
                                showWidget: true,
                              ),
                            ),
                          );
                        },
                        deleteFamily: () {});
                  },
                )),
          )
        ],
      ),
    );
  }
}
