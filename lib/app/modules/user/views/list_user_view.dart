import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/global/shimmer/shimmer_custom_user_card.dart';
import 'package:formapp/app/global/widgets/custom_app_bar.dart';
import 'package:formapp/app/global/widgets/custom_user_card.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/global/widgets/create_user_modal.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListUserView extends GetView<UserController> {
  ListUserView({super.key});

  final box = GetStorage('credenciado');

  final messageController = Get.put(MessageController());
  final familyController = Get.put(FamilyController());

  @override
  Widget build(BuildContext context) {
    var idUserLogged = box.read('auth')['user']['id'];
    final familiaId = controller.box.read('auth')['user']['familia_id'];
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15), topEnd: Radius.circular(15))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchWidget(
                controller: controller.searchController,
                onSearchPressed: (context, a, query) {
                  controller.searchUsers(query);
                }),
            Obx(() => controller.isLoading.value
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const ShimmerCustomUserCard();
                    },
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: controller.listUsers.length,
                        itemBuilder: (context, index) {
                          User user = controller.listUsers[index];

                          String typeUser = user.tipousuarioId == 1
                              ? "Master"
                              : (user.tipousuarioId == 2
                                  ? "Lider"
                                  : "Familiar");

                          bool desativaMaster = UserStorage.getUserType() == 1;
                          bool desativaLider = UserStorage.getUserType() == 1 ||
                              user.id == UserStorage.getUserId();
                          bool desativaFamiliar =
                              user.id == UserStorage.getUserId() ||
                                  desativaMaster ||
                                  desativaLider;

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: (!desativaMaster &&
                                      !desativaLider &&
                                      !desativaFamiliar)
                                  ? DismissDirection.none
                                  : DismissDirection.endToStart,
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  showDialog(context, user);
                                }
                                return false;
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: user.status == 1
                                      ? Colors.red.shade500
                                      : Colors.green,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          user.status == 1
                                              ? const Icon(Icons.delete_outline,
                                                  color: Colors.white, size: 25)
                                              : const Icon(
                                                  Icons.check_rounded,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: CustomUserCard(
                                  user: user,
                                  familiaId: familiaId,
                                  idUserLogged: idUserLogged,
                                  controller: controller,
                                  messageController: messageController,
                                  typeUser: typeUser),
                            ),
                          );
                        }),
                  ))
          ],
        ),
      ),
      floatingActionButton: UserStorage.getUserType() < 3
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF123d68),
              onPressed: () {
                if (familiaId == null) {
                  controller.clearAllUserTextFields();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: CreateUserModal(
                        tipoOperacao: 'insert',
                        titulo: 'Cadastro de Usuário',
                      ),
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  void showDialog(context, User user) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      titleStyle: CustomTextStyle.titleSplash(context),
      content: Text(
        textAlign: TextAlign.center,
        user.status == 0
            ? "Tem certeza que deseja ativar novamente o usuário ${user.nome} ?"
            : "Tem certeza que deseja desativar o usuário ${user.nome} ?",
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
            Map<String, dynamic> retorno = user.status == 0
                ? await controller.deleteUser(user.id!, 1)
                : await controller.deleteUser(user.id!, 0);
            if (retorno['return'] == 0) {
              Get.back();
            }
            Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(milliseconds: 1500),
              retorno['return'] == 0 ? 'Sucesso' : "Falha",
              retorno['message'],
              backgroundColor:
                  retorno['return'] == 0 ? Colors.green : Colors.red,
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
  }
}
