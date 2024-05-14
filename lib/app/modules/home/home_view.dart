import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
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
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 9.5),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Encontre um cadastro ...",
                        labelStyle: const TextStyle(
                            fontFamily: 'Poppinss', fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Últimos cadastros',
                    style: TextStyle(fontFamily: 'Poppinss', fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        itemCount: controller.listPeoples.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          People people = controller.listPeoples[index];

                          return Card(
                            margin: const EdgeInsets.all(2),
                            child: SizedBox(
                              height: 45,
                              child: ListTile(
                                dense: true,
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: people.foto
                                          .toString()
                                          .isEmpty
                                      ? const AssetImage(
                                          'assets/images/default_avatar.jpg')
                                      : NetworkImage(
                                              '$urlImagem/storage/app/public/${people.foto}')
                                          as ImageProvider,
                                ),
                                title: Text(
                                  people.nome!,
                                  style: const TextStyle(
                                      fontFamily: 'Poppinss',
                                      overflow: TextOverflow.ellipsis),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      CupertinoIcons.ellipsis,
                                      color: Colors.black54,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton(
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
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                ),
                Image.asset(
                  'assets/images/logo-wip.png',
                  width: 30,
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: Get.height / 4.7,
          left: 15,
          right: 15,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: SizedBox(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, top: 25, bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DynamicRichText(
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
    );
  }
}

class DynamicRichText extends StatelessWidget {
  final RxInt value;
  final String description;
  final TextStyle valueStyle;
  final TextStyle descriptionStyle;
  final Color? color;

  final bool isLargerText;

  const DynamicRichText(
      {Key? key,
      required this.value,
      required this.description,
      required this.valueStyle,
      required this.descriptionStyle,
      required this.color,
      required this.isLargerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              fontSize: isLargerText ? 85 : 20,
              fontFamily: isLargerText ? 'Poppinss' : 'Poppins',
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
