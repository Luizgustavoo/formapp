import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/repository/message_repository.dart';
import 'package:formapp/app/utils/connection_service.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class MessageController extends GetxController {
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  RxList<Message> listMessages = <Message>[].obs;
  final repository = Get.put(MessageRepository());

  Map<String, dynamic> retorno = {"return": 1, "message": ""};
  dynamic mensagem;
  RxInt quantidadeMensagensNaoLidas = 0.obs;
  final box = GetStorage('credenciado');
  var message = Message().obs;

  @override
  void onInit() {
    getMessages();
    super.onInit();
  }

  @override
  void onClose() {
    getMessages();
    super.onClose();
  }

  void getMessages() async {
    if (UserStorage.existUser()) {
      final token = UserStorage.getToken();
      listMessages.value = await repository.getAll("Bearer $token");

      quantidadeMensagensNaoLidas.value =
          listMessages.where((message) => message.lida == 'nao').length;
    }
  }

  Future<Map<String, dynamic>> saveMessage({Family? family, User? user}) async {
    Message message = Message(
      titulo: subjectController.text,
      descricao: messageController.text,
    );
    final token = box.read('auth')['access_token'];
    if (await ConnectionStatus.verifyConnection()) {
      mensagem = await repository.insertMessage(
          "Bearer $token", family, message, user);
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

  Future<Map<String, dynamic>> changeMessage(int messageId, int userId) async {
    final token = box.read('auth')['access_token'];
    if (await ConnectionStatus.verifyConnection()) {
      mensagem =
          await repository.messageChange("Bearer $token", messageId, userId);
      if (mensagem != null) {
        if (mensagem['message'] == 'success') {
          retorno = {"return": 0, "message": "Operação realizada com sucesso!"};
        }
      }
    }
    return retorno;
  }

  void clearModalMessage() {
    subjectController.value = TextEditingValue.empty;
    messageController.value = TextEditingValue.empty;
  }

  String get formattedDate {
    String? dataCadastro = message.value.dataCadastro;
    return dataCadastro != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dataCadastro))
        : '';
  }
}
