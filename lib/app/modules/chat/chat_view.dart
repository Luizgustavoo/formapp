import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
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
                    return ChatMessageWidget(
                      chat: chat,
                      remetenteId: UserStorage.getUserId(),
                      user: user,
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

  const ChatMessageWidget(
      {Key? key, required this.chat, required this.remetenteId, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSentByCurrentUser = UserStorage.getUserName() == user!.nome!;
    final Color backgroundColor =
        isSentByCurrentUser ? Colors.blue : Colors.grey[300]!;
    final Color textColor = isSentByCurrentUser ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: isSentByCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: isSentByCurrentUser
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
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Text(
                chat!.mensagem!,
                style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
