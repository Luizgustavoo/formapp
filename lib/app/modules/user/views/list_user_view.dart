import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/global/widgets/create_user_modal.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListUserView extends GetView<UserController> {
  ListUserView({super.key});

  final box = GetStorage('credenciado');

  @override
  Widget build(BuildContext context) {
    var idUserLogged = box.read('auth')['user']['id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Usuários'),
        actions: [
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
                      return Card(
                        child: ListTile(
                          leading: user.status == 1
                              ? IconButton(
                                  onPressed: () {
                                    controller.selectedUser = user;
                                    controller.fillInUserFields();
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      builder: (context) => Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
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
                              : const SizedBox(
                                  width: 50,
                                  height: 50,
                                ),
                          trailing: idUserLogged == user.id
                              ? const SizedBox(
                                  width: 50,
                                  height: 50,
                                )
                              : IconButton(
                                  onPressed: () async {
                                    showDialog(context, user);
                                  },
                                  icon: user.status == 1
                                      ? const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 25)
                                      : const Icon(Icons.check_rounded)),
                          title: Text(
                            user.nome!,
                            style: CustomTextStyle.subtitleNegrit(context),
                          ),
                          subtitle: Text(
                            user.username!,
                            style: CustomTextStyle.form(context),
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
