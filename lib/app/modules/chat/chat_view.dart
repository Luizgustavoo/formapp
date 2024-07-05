import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';
import 'package:ucif/app/utils/services.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final People people =
        Get.arguments != null ? Get.arguments as People : People();
    if (people.id != null) {
      controller.destinatarioId.value = people.id!;
    }
    controller.getChat();
    controller.chatChange();

    void scrollToBottomIfNeeded() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final screenHeight = MediaQuery.of(context).size.height;
        final desiredOffset = screenHeight - keyboardHeight;
        if (offset.dy < desiredOffset) {
          final scrollController = controller.scrollController;
          scrollController.animateTo(
            scrollController.offset + desiredOffset - offset.dy,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Role o ListView.builder para o final
      controller.scrollController
          .jumpTo(controller.scrollController.position.maxScrollExtent);
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (Services.getRoute() == '/detail-people') {
          Get.offAllNamed('/detail-people', arguments: people);
        } else {
          Get.offAllNamed(Services.getRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: Get.width * .25,
            title: Text(people.nome ?? ""),
            leading: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (Services.getRoute() == '/detail-people') {
                        Get.offAllNamed('/detail-people', arguments: people);
                      } else {
                        Get.offAllNamed(Services.getRoute());
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                    )),
                CircleAvatar(
                  backgroundImage: people.foto != null
                      ? NetworkImage(
                              '$urlImagem/storage/app/public/${people.foto}')
                          as ImageProvider<Object>?
                      : const AssetImage('assets/images/default_avatar.jpg'),
                )
              ],
            )),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(15),
              topEnd: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Obx(
                () => Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children:
                          List.generate(controller.listChats.length, (index) {
                        final chat = controller.listChats[index];
                        final mensagemRemetente =
                            chat.remetenteId == UserStorage.getPeopleId();
                        return Row(
                          mainAxisAlignment: mensagemRemetente
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            ChatMessageWidget(
                              mensagemRemetente: mensagemRemetente,
                              chat: chat,
                              remetenteId: UserStorage.getUserId(),
                              people: people,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: Get.height * 0.2,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller.chatController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Digite sua mensagem...',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => controller.sendChat(),
                              onTap: () {
                                scrollToBottomIfNeeded();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => controller.sendChat(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Chat? chat;
  final int? remetenteId;
  final People? people;
  final bool? mensagemRemetente;

  const ChatMessageWidget(
      {Key? key,
      required this.chat,
      required this.remetenteId,
      this.people,
      required this.mensagemRemetente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        mensagemRemetente! ? Colors.blue.shade200 : Colors.blue.shade50;
    const Color textColor = Colors.black87;

    DateTime dataDoBanco = DateTime.parse(chat!.dataCadastro!);
    String dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(dataDoBanco);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: mensagemRemetente!
            ? const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: !mensagemRemetente!
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Text(
              chat!.mensagem!,
              style: TextStyle(
                fontSize: 18.0,
                color: textColor,
                fontWeight: (!mensagemRemetente! && chat!.lida == 'nao')
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            dataFormatada,
            style: const TextStyle(
              fontSize: 12.0,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
