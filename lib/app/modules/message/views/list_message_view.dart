import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ucif/app/data/models/message_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_card_message.dart';
import 'package:ucif/app/modules/message/message_controller.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.getMessages();
    return Scaffold(
        appBar: CustomAppBar(
          showPadding: false,
          title: '',
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.getMessages();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFf1f5ff),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Notificações',
                    style: TextStyle(fontFamily: 'Poppinss', fontSize: 16),
                  ),
                  const Divider(
                    height: 5,
                    thickness: 2,
                    color: Color(0xFF1C6399),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.listMessages.length,
                            itemBuilder: (context, index) {
                              Message message = controller.listMessages[index];
                              return CustomCardMessage(
                                message: message,
                              );
                            }),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
