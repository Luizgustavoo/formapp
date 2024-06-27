import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_people_card.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_people_card.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/utils/user_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> user = UserStorage.getUserName().split(' ');
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            userName: user[0],
            showPadding: true,
            title: '',
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFFf1f5ff),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserStorage.getUserType() < 3
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * .12)
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                  if (UserStorage.getUserType() != 3) ...[
                    SizedBox(
                      height: 35,
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          labelText: "Encontre um cadastro ...",
                          labelStyle: const TextStyle(
                              fontFamily: 'Poppinss', fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
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
                  ],
                  Text(
                    UserStorage.getUserType() != 3
                        ? 'Últimos cadastros'
                        : 'Membros da Família',
                    style:
                        const TextStyle(fontFamily: 'Poppinss', fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () {
                      if (controller.isLoading.value) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const ShimmerCustomPeopleCard();
                            },
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: controller.listPeoples.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              People people = controller.listPeoples[index];
                              return CustomPeopleCard(
                                people: people,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Color(0xFFf1f5ff),
            ),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UserStorage.getUserType() == 3 ? 50 : 80),
                  child: SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: UserStorage.getUserType() == 3
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed('/list-family');
                                  },
                                  child: const Text(
                                    'VER FAMÍLIA',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppinss'),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed('/list-user');
                                  },
                                  child: const Text(
                                    'VER LIDERANÇA',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppinss'),
                                  )),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/list-people');
                            },
                            child: const Text(
                              'VER TODOS',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Poppinss'),
                            )),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Copyright © ${DateTime.now().year} UCIF - Todos os direitos reservados',
                  style: const TextStyle(
                    fontSize: 8,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                ),
                Image.asset(
                  'assets/images/logo-wip.png',
                  width: 44,
                  height: 44,
                ),
              ],
            ),
          ),
        ),
        if (UserStorage.getUserType() < 3) ...[
          Positioned(
            top: (MediaQuery.of(context).size.height -
                    CustomAppBar().preferredSize.height) *
                .28,
            left: MediaQuery.of(context).size.width * .04,
            right: MediaQuery.of(context).size.width * .04,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              margin: const EdgeInsets.all(16),
              elevation: 5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .16,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 16, left: 16, top: 12, bottom: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DynamicRichText(
                        isBold: true,
                        value: controller.counter2,
                        description: 'Pessoas Cadastradas',
                        valueStyle: const TextStyle(
                          fontFamily: 'Poppinss',
                        ),
                        descriptionStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        isLargerText: true,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed('/list-family');
                            },
                            child: DynamicRichText(
                              isBold: false,
                              value: controller.counter,
                              description: 'Famílias',
                              valueStyle: const TextStyle(
                                fontFamily: 'Poppinss',
                                height: 1,
                              ),
                              descriptionStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                              isLargerText: false,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Get.toNamed('/list-user');
                            },
                            child: DynamicRichText(
                              isBold: false,
                              value: controller.counter3,
                              description: 'Lideranças',
                              valueStyle: const TextStyle(
                                fontFamily: 'Poppinss',
                                height: 1,
                              ),
                              descriptionStyle: const TextStyle(
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                              isLargerText: false,
                              color: Colors.green,
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
      ],
    );
  }
}

class DynamicRichText extends StatelessWidget {
  final RxInt value;
  final String description;
  final TextStyle valueStyle;
  final TextStyle descriptionStyle;
  final Color? color;
  final bool isBold;

  final bool isLargerText;

  const DynamicRichText(
      {Key? key,
      required this.value,
      required this.description,
      required this.valueStyle,
      required this.descriptionStyle,
      required this.color,
      required this.isLargerText,
      required this.isBold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              fontSize: isLargerText ? 45 : 20,
              fontFamily: isLargerText ? 'Poppinss' : 'Poppins',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              height: 1,
            ),
            children: [
              TextSpan(
                text: isLargerText ? '\n$description' : ' $description',
                style: TextStyle(
                  fontSize: isLargerText ? 20 : 16,
                  fontFamily: isLargerText ? 'Poppinss' : 'Poppinss',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}
