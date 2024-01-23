import 'package:flutter/material.dart';
import 'package:formapp/widgets/custom_list_tile.dart';

class CustomDrawerFamily extends StatelessWidget {
  const CustomDrawerFamily({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'NOME DO USUÁRIO',
                                  style: TextStyle(
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
              CustomListTile(Icons.home_outlined, 'HOME', () {}, true),
              CustomListTile(Icons.pin_drop_outlined, 'ENDEREÇO', () {}, true),
              CustomListTile(Icons.exit_to_app_rounded, 'SAIR', () {}, true),
            ],
          ),
        ),
      ),
    );
  }
}
