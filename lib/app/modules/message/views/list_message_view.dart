import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:formapp/app/global/widgets/custom_card_message.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:get/get.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Mensagens Recebidas')),
        body: Obx(() => ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.listMessages.length,
            itemBuilder: (context, index) {
              Message message = controller.listMessages[index];
              return CustomCardMessage(
                title: message.titulo,
                date: DateTime.parse(message.dataCadastro!),
                desc: message.descricao,
              );
            })));
  }
}
