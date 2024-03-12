import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/custom_list_tile.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

class CustomDrawer extends GetView<HomeController> {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Get.size;

    return SafeArea(
      child: SizedBox(
        width: size.width * 0.70,
        height: size.height,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: size.height * .2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade500,
                      Colors.orange.shade300,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme:
                        const DividerThemeData(color: Colors.transparent),
                  ),
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: Divider.createBorderSide(context,
                                color: Colors.transparent, width: 0.0))),
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Obx(() => Text(
                                      controller.username.value.isNotEmpty
                                          ? controller.username.value
                                              .toUpperCase()
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: 'Poppins'),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              CustomListTile(Icons.home_rounded, 'HOME', () {}, true),
              CustomListTile(Icons.exit_to_app_rounded, 'SAIR', () {
                controller.exit();
              }, true),
            ],
          ),
        ),
      ),
    );
  }
}
