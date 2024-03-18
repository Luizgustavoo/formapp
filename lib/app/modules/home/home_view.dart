import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/global/widgets/custom_graphic.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';

import 'package:formapp/app/global/widgets/custom_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> user = UserStorage.getUserName().split(' ');
    return Scaffold(
      appBar: CustomAppBar(
        userName: user[0],
        showPadding: true,
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
                        InkWell(
                          onTap: () {
                            Get.toNamed("/list-family");
                          },
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                color: Color(0xFF123d68),
                                width: 1,
                              ),
                            ),
                            shadowColor: const Color(0xFF123d68),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        textAlign: TextAlign.center,
                                        controller.counter.value.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 40,
                                            color: Color(0xfffc9805)),
                                      )),
                                  Text(
                                    'Famílias\ncadastradas',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.homeCount(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Get.toNamed("/list-people");
                          },
                          child: Card(
                            shadowColor: const Color(0xFF123d68),
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                color: Color(0xFF123d68),
                                width: 1,
                              ),
                            ),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        textAlign: TextAlign.center,
                                        controller.counter2.value.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 40,
                                            color: Color(0xfffc9805)),
                                      )),
                                  Text(
                                    'Pessoas\ncadastradas',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.homeCount(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
              'Copyright © ${DateTime.now().year} Adbras - Todos os direitos reservados',
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
