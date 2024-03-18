// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/global/widgets/create_user_modal.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:formapp/app/utils/user_storage.dart';

class CustomUserCard extends StatelessWidget {
  CustomUserCard({
    super.key,
    required this.user,
    required this.familiaId,
    required this.idUserLogged,
    required this.controller,
    required this.messageController,
    required this.typeUser,
  });

  final User user;
  var familiaId;
  var idUserLogged;
  final UserController controller;

  final MessageController messageController;
  final String typeUser;

  @override
  Widget build(BuildContext context) {
    bool editaMaster = UserStorage.getUserType() == 1;
    bool editaLider =
        UserStorage.getUserType() == 1 || user.id == UserStorage.getUserId();
    bool editaFamiliar = user.id == UserStorage.getUserId();

    return Card(
      color: user.tipousuarioId == 2 ? const Color(0xFF123d68) : null,
      child: ListTile(
        leading: (editaMaster || editaLider || editaFamiliar)
            ? IconButton(
                onPressed: () {
                  controller.selectedUser = user;
                  controller.fillInUserFields();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: CreateUserModal(
                        tipoOperacao: 'update',
                        titulo: 'Alteração de Usuário',
                        user: user,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined,
                    color: Colors.blue, size: 25),
              )
            : const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
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
                      padding: MediaQuery.of(context).viewInsets,
                      child: MessageModal(
                        user: user,
                        titulo: 'Mensagem para ${user.nome}',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.message_outlined,
                  size: 25,
                  color: user.tipousuarioId == 2 ? Colors.white : Colors.green,
                )),
        title: Text(
          user.nome!,
          style: user.tipousuarioId == 2
              ? CustomTextStyle.subtitleWhite(context)
              : CustomTextStyle.subtitleNegrit(context),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.username!,
              style: user.tipousuarioId == 2
                  ? CustomTextStyle.formWhite(context)
                  : CustomTextStyle.form(context),
            ),
            Text(
              "Usuário $typeUser",
              style: user.tipousuarioId == 2
                  ? CustomTextStyle.formWhite(context)
                  : CustomTextStyle.form(context),
            ),
          ],
        ),
      ),
    );
  }
}
