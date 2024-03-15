import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/global/widgets/custom_graphic.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';

import 'package:formapp/app/global/widgets/custom_card.dart';
import 'package:formapp/app/global/widgets/custom_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> user = UserStorage.getUserName().split(' ');
    return Scaffold(
      appBar: CustomAppBar(
        userName: user[0],
        showPadding: true,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15), topEnd: Radius.circular(15))),
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
                  )),
              const CategoryItems(),
              const Divider(
                endIndent: 20,
                indent: 20,
                height: 3,
                thickness: 2,
                color: Color(0xfffc9805),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          '8600',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 40,
                              color: Color(0xfffc9805)),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'Famílias\ncadastradas',
                          style: CustomTextStyle.homeCount(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          textAlign: TextAlign.center,
                          '2580',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 40,
                              color: Color(0xfffc9805)),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'Pessoas\ncadastradas',
                          style: CustomTextStyle.homeCount(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const GraphicWidget()
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
                  fontSize: 12, fontFamily: 'Poppinss', color: Colors.black54),
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
      padding: const EdgeInsets.all(16),
      children: [
        CustomCard(
          ontap: () {
            Get.toNamed("/list-family");
          },
          title: 'Famílias',
          imageUrl: 'assets/images/familia_icon.png',
        ),
        CustomCard(
          ontap: () {
            Get.toNamed('/list-people');
          },
          title: 'Pessoas',
          imageUrl: 'assets/images/pessoa_icon.png',
        ),
        CustomCard(
          ontap: () {},
          title: 'Liderança',
          imageUrl: 'assets/images/lider_icon.png',
        ),
      ],
    );
  }
}
