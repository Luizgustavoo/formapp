import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments != null ? Get.arguments as User : User();
    if (user.id != null) {
      controller.destinatarioId.value = user.id!;
    }
    controller.getMessages();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(user.nome ?? ""),
        // leading: IconButton(
        //     onPressed: () {
        //       Get.offAllNamed('/list-user');
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //     )),
      ),
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
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.listChats.length,
                  itemBuilder: (context, index) {
                    final chat = controller.listChats[index];
                    var mensagemRemetente =
                        chat.remetenteId == UserStorage.getUserId();
                    return Row(
                      mainAxisAlignment: mensagemRemetente
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        ChatMessageWidget(
                          mensagemRemetente: mensagemRemetente,
                          chat: chat,
                          remetenteId: UserStorage.getUserId(),
                          user: user,
                        ),
                      ],
                    );
                  },
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
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Chat? chat;
  final int? remetenteId;
  final User? user;
  final bool? mensagemRemetente;

  const ChatMessageWidget(
      {Key? key,
      required this.chat,
      required this.remetenteId,
      this.user,
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
