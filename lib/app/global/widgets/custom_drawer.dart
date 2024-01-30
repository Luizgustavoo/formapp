import 'package:flutter/material.dart';
import 'package:formapp/app/global/widgets/custom_list_tile.dart';
import 'package:formapp/app/modules/home/home_controller.dart';
import 'package:formapp/app/screens/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomDrawer extends GetView<HomeController> {
  String nome;
  CustomDrawer({super.key, required this.nome});

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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Material(
                        //       color: Colors.white,
                        //       elevation: 3,
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(60)),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(5),
                        //         child: CircleAvatar(
                        //           radius: size.width * .15,
                        //           backgroundImage: const AssetImage(
                        //               'assets/images/familia.png'),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  nome,
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: 'Poppins'),
                                ),
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
              CustomListTile(
                  Icons.settings_rounded, 'CONFIGURAÇÕES', () {}, true),
              CustomListTile(Icons.exit_to_app_rounded, 'SAIR', () {
                controller.box.remove('auth');
                Get.to(const LoginPage());
              }, true),
            ],
          ),
        ),
      ),
    );
  }
}
