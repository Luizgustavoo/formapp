import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/repository/chat_repository.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ChatController extends GetxController {
  final chatController = TextEditingController();
  RxList<Chat> listChats = <Chat>[].obs;
  final repository = Get.put(ChatRepository());
  final RxInt destinatarioId = 0.obs;
  final ScrollController scrollController = ScrollController();
  dynamic mensagem;
  final token = UserStorage.getToken();
  void getChat() async {
    if (UserStorage.existUser() && await ConnectionStatus.verifyConnection()) {
      final token = UserStorage.getToken();

      listChats.value =
          await repository.getAll("Bearer $token", destinatarioId.value);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

  Future<void> sendChat() async {
    final mensagem = await repository.sendChat(
        "Bearer $token", destinatarioId.value, chatController.text);
    if (mensagem != null && await ConnectionStatus.verifyConnection()) {
      getChat();
      chatController.clear();
    }
  }

  Future<void> chatChange() async {
    if (await ConnectionStatus.verifyConnection()) {
      mensagem =
          await repository.chatChange("Bearer $token", destinatarioId.value);
      if (mensagem != null && await ConnectionStatus.verifyConnection()) {
        getChat();
        chatController.clear();
      }
    }
  }
}
