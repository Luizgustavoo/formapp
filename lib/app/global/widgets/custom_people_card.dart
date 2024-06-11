import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/create_new_user_modal.dart';
import 'package:ucif/app/global/widgets/family_list_modal.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

import '../../utils/user_storage.dart';

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
            : DismissDirection.horizontal,
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            await showModalBottomSheet(
              context: context,
              builder: (context) => FamilyListModal(
                people: people,
              ),
            );
            return false;
          } else if ((people.userSistema == null)) {
            if (direction == DismissDirection.endToStart) {
              final controller = Get.put(UserController());
              controller.clearAllUserTextFields();
              controller.getTypeUser();
              await showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: CreateNewUserModal(
                    titulo: 'Usuário',
                    people: people,
                  ),
                ),
              );
              return false;
            }
          }

          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF014acb),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.list_rounded, color: Colors.white),
                  Text(
                    'Alterar Família',
                    style: CustomTextStyle.button(context),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: people.userSistema == null
                ? Colors.green.shade300
                : Colors.red.shade300,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (people.userSistema == null
                        ? 'Cadastrar usuário'
                        : 'Usuário já existe'),
                    style: CustomTextStyle.button(context),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.person_add, color: Colors.white),
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
            onLongPress: UserStorage.getUserType() >=3 ? null : () async{
              final peopleController = Get.put(PeopleController());

              Get.defaultDialog(
                titlePadding: const EdgeInsets.all(16),
                contentPadding: const EdgeInsets.all(16),
                title: "Confirmação",
                content: Text("Deseja remover a pessoa ${people.nome}?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppinss',
                    fontSize: 18,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {

                       Map<String,dynamic> retorno = await ConnectionStatus.verifyConnection() && !people.peopleLocal!
                        ? await peopleController.deletePeople(people.id!, false) : await peopleController.deletePeopleLocal(people.id!);

                       print(retorno);

                      if (retorno['code'] == 0) {
                        Get.back();
                      }

                      Get.snackbar(
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(milliseconds: 1500),
                        retorno['code'] == 0 ? 'Sucesso' : "Falha",
                        retorno['message'],
                        backgroundColor:
                        retorno['code'] == 0 ? Colors.green : Colors.red,
                        colorText: Colors.white,
                      );
                    },
                    child: Text(
                      "Confirmar",
                      style: CustomTextStyle.button(context),
                    ),
                  ),
                ],
              );




            },
            onTap: () {
              Get.toNamed('/detail-people', arguments: people);
            },
            dense: true,
            titleAlignment: ListTileTitleAlignment.center,
            leading: CircleAvatar(
              radius: 15,
              backgroundImage:
                  people.foto.toString().isEmpty || people.foto == null
                      ? const AssetImage('assets/images/default_avatar.jpg')
                      : CachedNetworkImageProvider(
                              '$urlImagem/storage/app/public/${people.foto}')
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
                            colorText: Colors.white,
                            backgroundColor: Colors.green);
                      } else {
                        Get.snackbar('Falha', mensagem['message'],
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
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
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
