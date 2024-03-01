import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:formapp/app/data/repository/message_repository.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MessageController extends GetxController {
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final repository = Get.find<MessageRepository>();

  Map<String, dynamic> retorno = {"return": 1, "message": ""};
  dynamic mensagem;
  final box = GetStorage('credenciado');

  Future<Map<String, dynamic>> saveMessage(Family family) async {
    Message message = Message(
      titulo: subjectController.text,
      descricao: messageController.text,
      data: '2024-03-01',
    );

    final token = box.read('auth')['access_token'];

    if (await ConnectionStatus.verifyConnection()) {
      mensagem =
          await repository.insertMessage("Bearer $token", family, message);
      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        }
      } else if (mensagem['message'] == 'ja_existe') {
        retorno = {
          "return": 1,
          "message": "Já existe uma família com esse nome!"
        };
      }
    }

    return retorno;
  }
}
