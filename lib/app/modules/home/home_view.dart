import 'package:flutter/material.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/screens/family/home_page_family.dart';
import 'package:get/get.dart';

import 'package:formapp/app/global/widgets/custom_card.dart';
import 'package:formapp/app/global/widgets/custom_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: const Text(
                  'Serviços',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.orange.shade500,
                ),
              ),
            ],
          ),
          const Expanded(child: CategoryItems())
        ],
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 1,
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        padding: const EdgeInsets.all(8),
        children: [
          CustomCard(
              title: 'Famílias',
              ontap: () {
                Get.toNamed("/list-family");
              },
              imageUrl: 'assets/images/users.png'),
          CustomCard(
              title: 'Usuários',
              ontap: () {
                Get.toNamed('/list-user');
              },
              imageUrl: 'assets/images/user.png'),
          CustomCard(
              title: 'Atendimentos',
              ontap: () {
                Get.toNamed('/list-people');
              },
              imageUrl: 'assets/images/atendimento.png'),
          CustomCard(
              title: 'Mensagens',
              ontap: () {
                Get.to(() => const HomePageFamily());
              },
              imageUrl: 'assets/images/mensage.png'),
        ],
      ),
    );
  }
}
