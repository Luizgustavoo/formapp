// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/global/widgets/create_user_modal.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';
import 'package:badges/badges.dart' as badges;

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
  final chatController = Get.put(ChatController());
  final familyController = Get.put(FamilyController());
  final String typeUser;

  @override
  Widget build(BuildContext context) {
    bool editaMaster = UserStorage.getUserType() == 1;
    bool editaLider =
        UserStorage.getUserType() == 1 || user.id == UserStorage.getUserId();
    bool editaFamiliar = user.id == UserStorage.getUserId();

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
      color: user.tipousuarioId == 2 ? const Color(0xFF1C6399) : null,
      child: InkWell(
        onTap: UserStorage.getUserType() == 1
            ? () {
                familyController.selectedUser = user;
                familyController.getFamiliesFilter(user);
                Get.toNamed('/filter-family');
              }
            : () {},
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
                          titulo: 'Editar Usuário',
                          user: user,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined,
                      color: user.tipousuarioId == 2
                          ? Colors.white
                          : Colors.blue.shade700,
                      size: 25),
                )
              : const CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      AssetImage('assets/images/default_avatar.jpg'),
                ),
          trailing: idUserLogged == user.id
              ? const SizedBox(
                  width: 50,
                  height: 50,
                )
              : Stack(
                  children: [
                    IconButton(
                        onPressed: () async {
                          chatController.destinatarioId.value = user.id!;
                          chatController.chatChange();
                          Get.toNamed('/chat', arguments: user);
                        },
                        icon: Icon(
                          Icons.message_outlined,
                          size: 25,
                          color: user.tipousuarioId == 2
                              ? Colors.white
                              : Colors.blue.shade700,
                        )),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: user.mensagens > 0
                          ? badges.Badge(
                              showBadge: true,
                              ignorePointer: false,
                              badgeContent: Text(
                                user.mensagens.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                              badgeAnimation:
                                  const badges.BadgeAnimation.rotation(
                                animationDuration: Duration(seconds: 1),
                                colorChangeAnimationDuration:
                                    Duration(seconds: 1),
                                loopAnimation: false,
                                curve: Curves.easeInOut,
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
          title: Text(
            user.nome!,
            style: user.quantidadeFamilias > 0
                ? CustomTextStyle.subtitleFamily(context)
                : user.tipousuarioId == 2
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
      ),
    );
  }
}
