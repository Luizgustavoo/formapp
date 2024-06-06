import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/family_list_modal.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class CustomPeopleCard extends StatelessWidget {
  CustomPeopleCard({
    super.key,
    required this.people,
  });

  final People people;

  final box = GetStorage('credenciado');

  @override
  Widget build(BuildContext context) {
    final familiaId = box.read('auth')['user']['familia_id'];
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Dismissible(
        key: UniqueKey(),
        direction: familiaId != null ||
                Get.currentRoute == '/home' ||
                Get.currentRoute == '/filter-family' ||
                people.peopleLocal!
            ? DismissDirection.none
            : DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            await showModalBottomSheet(
              context: context,
              builder: (context) => FamilyListModal(
                people: people,
              ),
            );
          }
          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.orange.shade300,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    'Alterar Família',
                    style: CustomTextStyle.button(context),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.list_rounded, color: Colors.white)
                ],
              ),
            ),
          ),
        ),
        child: Card(
          color: people.peopleLocal! ? const Color(0xFF014acb) : Colors.white,
          elevation: 1,
          margin: const EdgeInsets.only(left: 0, right: 0, top: 2),
          child: ListTile(
            onTap: () {
              Get.toNamed('/detail-people', arguments: people);
            },
            dense: true,
            titleAlignment: ListTileTitleAlignment.center,
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: people.foto.toString().isEmpty
                  ? const AssetImage('assets/images/default_avatar.jpg')
                  : NetworkImage('$urlImagem/storage/app/public/${people.foto}')
                      as ImageProvider,
            ),
            title: Text(people.nome!.toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppinss',
                    fontSize: 12,
                    color: people.peopleLocal! ? Colors.white : Colors.black)),
            trailing: people.peopleLocal!
                ? IconButton(
                    onPressed: () async {
                      final controller = Get.put(PeopleController());
                      Map<String, dynamic> mensagem =
                          await controller.sendPeopleToAPIOffline(people);
                      if (mensagem['return'] == 0) {
                        Get.snackbar('Sucesso', mensagem['message'],
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green);
                      } else {
                        Get.snackbar('Falha', mensagem['message'],
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red);
                      }
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.white,
                    ))
                : IconButton(
                    onPressed: () {
                      Get.toNamed('/detail-people', arguments: people);
                    },
                    icon: const Icon(
                      Icons.remove_red_eye_rounded,
                      size: 20,
                      color: Colors.black54,
                    )),
          ),
        ),
      ),
    );
  }
}
