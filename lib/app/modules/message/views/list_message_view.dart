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
        ),
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(15), topEnd: Radius.circular(15))),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(() => Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
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
        ));
  }
}
