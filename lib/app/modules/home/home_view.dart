import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_count_card.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_card.dart';
import 'package:ucif/app/global/widgets/custom_count_card.dart';
import 'package:ucif/app/global/widgets/custom_graphic.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> user = UserStorage.getUserName().split(' ');

    return Scaffold(
      appBar: CustomAppBar(
        userName: user[0],
        showPadding: true,
        title: '',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            topEnd: Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                child: Text(
                  'Cadastros',
                  style: CustomTextStyle.title(context),
                ),
              ),
              const CategoryItems(),
              if (UserStorage.getUserType() <= 2) ...[
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 3,
                  thickness: 2,
                  color: Color(0xfffc9805),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 200,
                      child: GraphicWidget(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          if (controller.isGraphicLoading.value) {
                            // Exibir ShimmerCustomCountCard enquanto está carregando
                            return const ShimmerCustomCountCard();
                          } else {
                            // Exibir CustomCountCard quando os dados estiverem carregados
                            return CustomCountCard(
                              title: 'Famílias\ncadastradas',
                              counter: controller.counter,
                              onTap: () {
                                Get.toNamed("/list-family");
                              },
                            );
                          }
                        }),
                        const SizedBox(height: 5),
                        Obx(() {
                          if (controller.isGraphicLoading.value) {
                            return const ShimmerCustomCountCard();
                          } else {
                            return CustomCountCard(
                              title: 'Pessoas\ncadastradas',
                              counter: controller.counter2,
                              onTap: () {
                                Get.toNamed("/list-people");
                              },
                            );
                          }
                        }),
                        const SizedBox(height: 5),
                        Obx(() {
                          if (controller.isGraphicLoading.value) {
                            return const ShimmerCustomCountCard();
                          } else {
                            return CustomCountCard(
                              title: 'Lideranças\ncadastradas',
                              counter: controller.counter3,
                              onTap: () {
                                Get.toNamed("/list-user");
                              },
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 5),
        width: 75,
        height: 75,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Copyright © ${DateTime.now().year} UCIF - Todos os direitos reservados',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),
            Image.asset(
              'assets/images/logo-wip.png',
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      padding: const EdgeInsets.all(8),
      children: [
        CustomCard(
          onTap: () {
            Get.toNamed("/list-family");
          },
          title: 'Famílias',
          imageUrl: 'assets/images/familia_icon.png',
        ),
        CustomCard(
          onTap: () {
            Get.toNamed('/list-people');
          },
          title: 'Pessoas',
          imageUrl: 'assets/images/pessoa_icon.png',
        ),
        CustomCard(
          onTap: () {
            Get.toNamed('/list-user');
          },
          title: 'Liderança',
          imageUrl: 'assets/images/lider_icon.png',
        ),
      ],
    );
  }
}
