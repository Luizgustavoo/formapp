import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/unread_message_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/utils/services.dart';

class UnreadView extends GetView<MessageController> {
  const UnreadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '',
          showPadding: false,
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.getUnreadMessages(),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFf1f5ff),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Mensagens não lidas',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  ),
                  const Divider(
                    height: 5,
                    thickness: 2,
                    color: Color(0xFF1C6399),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.listUnreadMessages.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount:
                                        controller.listUnreadMessages.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (ctx, index) {
                                      UnreadMessage unreadMessage =
                                          controller.listUnreadMessages[index];
                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: unreadMessage.foto
                                                        .toString()
                                                        .isEmpty ||
                                                    unreadMessage.foto == null
                                                ? const AssetImage(
                                                    'assets/images/default_avatar.jpg')
                                                : CachedNetworkImageProvider(
                                                        '$urlImagem/storage/app/public/${unreadMessage.foto}')
                                                    as ImageProvider,
                                          ),
                                          onTap: () {
                                            final chatController =
                                                Get.put(ChatController());
                                            chatController
                                                    .destinatarioId.value =
                                                unreadMessage.pessoaId!;
                                            chatController.chatChange();
                                            Services.setRoute(
                                                '/list-unread-message');
                                            Get.toNamed(
                                              '/chat',
                                              arguments: People(
                                                id: unreadMessage.remetenteId,
                                                nome: unreadMessage.nome,
                                                foto: unreadMessage.foto,
                                              ),
                                            );
                                          },
                                          title: Text(unreadMessage.nome!),
                                        ),
                                      );
                                    }))
                            : const Center(
                                child: Text(
                                  'NÃO HÁ MENSAGENS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black54,
                                      fontSize: 20),
                                ),
                              ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
