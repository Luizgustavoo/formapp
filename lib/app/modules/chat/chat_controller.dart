import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/repository/chat_repository.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ChatController extends GetxController {
  final chatController = TextEditingController();
  RxList<Chat> listChats = <Chat>[].obs;
  final repository = Get.put(ChatRepository());
  final RxInt destinatarioId = 0.obs;

  void getMessages() async {
    if (UserStorage.existUser()) {
      final token = UserStorage.getToken();
      final rementeId = UserStorage.getUserId();
      print("REMETENTE: $rementeId");
      print("DESTINATÁRIO: ${destinatarioId.value}");
      listChats.value = await repository.getAll(
          "Bearer $token", rementeId, destinatarioId.value);
    }
  }

  void handleSubmitted(String text) {
    chatController.clear();
    // Aqui você pode adicionar a lógica para enviar a mensagem
    print("Mensagem enviada: $text");
  }
}
