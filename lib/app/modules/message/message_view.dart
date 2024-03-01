import 'package:flutter/material.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:get/get.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Mensagens Recebidas')),
        body: const SafeArea(child: Text('MessageController')));
  }
}
