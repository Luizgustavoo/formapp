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
    final User user = Get.arguments as User;
    controller.destinatarioId.value = user.id!;
    controller.getMessages();

    return Scaffold(
      appBar: AppBar(
        title: Text(user.nome!),
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
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller.chatController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Digite sua mensagem...',
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: controller.handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              controller.handleSubmitted(controller.chatController.text);
            },
          ),
        ],
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
          Text(
            chat!.mensagem!,
            style: TextStyle(
              fontSize: 18.0,
              color: textColor,
              fontWeight: (!mensagemRemetente! && chat!.lida == 'nao')
                  ? FontWeight.bold
                  : FontWeight.normal,
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
