import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/global/widgets/create_family_modal.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

// ignore: must_be_immutable
class CustomFamilyCard extends StatelessWidget {
  Family family;

  CustomFamilyCard({
    Key? key,
    required this.family,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: family.familyLocal! ? const Color(0xFF014acb) : Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: ListTile(
        onLongPress: UserStorage.getUserType() >= 3
            ? null
            : () async {
                final familyController = Get.put(FamilyController());

                Get.defaultDialog(
                  titlePadding: const EdgeInsets.all(16),
                  contentPadding: const EdgeInsets.all(16),
                  title: "Confirmação",
                  content: Text(
                    "Deseja remover a família ${family.nome}?",
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
                        Map<String, dynamic> retorno =
                            await ConnectionStatus.verifyConnection() &&
                                    !family.familyLocal!
                                ? await familyController.deleteFamily(
                                    family.id!, false)
                                : await familyController.deleteFamily(
                                    family.id!, true);

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
          final controller = Get.put(PeopleController());

          controller.getFamilyMembers(family.id);
          Get.toNamed('/member-family');
        },
        title: Text('Família: ${family.nome!}',
            style: TextStyle(
                fontFamily: 'Poppinss',
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: family.familyLocal! ? Colors.white : Colors.black)),
        subtitle: Text('Total de membros: ${family.pessoas!.length}',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: family.familyLocal! ? Colors.white : Colors.black)),
        leading: family.familyLocal!
            ? IconButton(
                onPressed: Get.currentRoute == '/filter-family'
                    ? null
                    : () {
                        final controller = Get.put(FamilyController());
                        controller.selectedFamily = family;
                        controller.fillInFields();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: CreateFamilyModal(
                              tipoOperacao: 'update',
                              titulo: 'Editar Família',
                              family: family,
                            ),
                          ),
                        );
                      },
                icon: Get.currentRoute == '/filter-family'
                    ? const SizedBox()
                    : Icon(
                        Icons.edit_note_sharp,
                        color: family.familyLocal!
                            ? Colors.white
                            : Colors.grey.shade200,
                      ))
            : const SizedBox(),
        trailing: family.familyLocal!
            ? IconButton(
                onPressed: () async {
                  final controller = Get.put(FamilyController());

                  Map<String, dynamic> mensagem =
                      await controller.sendFamilyToAPIOffline(family);
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
                  color: Colors.white,
                ))
            : IconButton(
                onPressed: Get.currentRoute == '/filter-family'
                    ? null
                    : () {
                        final controller = Get.put(FamilyController());
                        controller.selectedFamily = family;
                        controller.fillInFields();
                        showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: CreateFamilyModal(
                              tipoOperacao: 'update',
                              titulo: 'Editar Família',
                              family: family,
                            ),
                          ),
                        );
                      },
                icon: Get.currentRoute == '/filter-family'
                    ? const SizedBox()
                    : Icon(
                        Icons.edit_note_sharp,
                        color: family.familyLocal!
                            ? Colors.white
                            : Colors.grey.shade800,
                      )),
      ),
    );
  }

  void showDialog(context, Family family) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      titleStyle: CustomTextStyle.titleSplash(context),
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja remover a ${family.nome} ?",
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
          child: Text(
            "Cancelar",
            style: CustomTextStyle.button2(context),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // final familyController = Get.put(FamilyController());
            // Map<String, dynamic> retorno =
            //     await familyController.deleteFamily(family.id!);

            // if (retorno['return'] == 0) {
            //   Get.back();
            // }
            // Get.snackbar(
            //   snackPosition: SnackPosition.BOTTOM,
            //   duration: const Duration(milliseconds: 1500),
            //   retorno['return'] == 0 ? 'Sucesso' : "Falha",
            //   retorno['message'],
            //   backgroundColor:
            //       retorno['return'] == 0 ? Colors.green : Colors.red,
            //   colorText: Colors.white,
            // );
          },
          child: Text(
            "Confirmar",
            style: CustomTextStyle.button(context),
          ),
        ),
      ],
    );
  }
}
