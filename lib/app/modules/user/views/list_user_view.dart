import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/global/widgets/create_user_modal.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListUserView extends GetView<UserController> {
  ListUserView({super.key});

  final box = GetStorage('credenciado');

  final messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    var idUserLogged = box.read('auth')['user']['id'];
    final familiaId = controller.box.read('auth')['user']['familia_id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Usuários'),
        actions: [
          if (familiaId == null) ...[
            IconButton(
                onPressed: () {
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
                },
                icon: const Icon(Icons.add_rounded))
          ]
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: controller.searchController,
              onSearchPressed: (context, a, query) {
                controller.searchUsers(query);
              }),
          Obx(() => Expanded(
                child: ListView.builder(
                    itemCount: controller.listUsers.length,
                    itemBuilder: (context, index) {
                      User user = controller.listUsers[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: familiaId != null
                              ? DismissDirection.none
                              : DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          child: Card(
                            child: ListTile(
                              leading: user.status == 1 &&
                                      familiaId != null &&
                                      idUserLogged == user.id
                                  ? IconButton(
                                      onPressed: () {
                                        controller.selectedUser = user;
                                        controller.fillInUserFields();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: CreateUserModal(
                                              tipoOperacao: 'update',
                                              titulo: 'Alteração de Usuário',
                                              user: user,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Colors.blue, size: 25))
                                  : user.status == 1 && familiaId == null
                                      ? IconButton(
                                          onPressed: () {
                                            controller.selectedUser = user;
                                            controller.fillInUserFields();
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              isDismissible: false,
                                              context: context,
                                              builder: (context) => Padding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                child: CreateUserModal(
                                                  tipoOperacao: 'update',
                                                  titulo:
                                                      'Alteração de Usuário',
                                                  user: user,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit_outlined,
                                              color: Colors.blue, size: 25))
                                      : const CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'assets/images/default_avatar.jpg'),
                                        ),
                              trailing: idUserLogged == user.id
                                  ? const SizedBox(
                                      width: 50,
                                      height: 50,
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        messageController.clearModalMessage();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: MessageModal(
                                              user: user,
                                              titulo:
                                                  'Mensagem para ${user.nome}',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.message_outlined,
                                        size: 25,
                                        color: Colors.green,
                                      )),
                              title: Text(
                                user.nome!,
                                style: CustomTextStyle.subtitleNegrit(context),
                              ),
                              subtitle: Text(
                                user.username!,
                                style: CustomTextStyle.form(context),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ))
        ],
      ),
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
