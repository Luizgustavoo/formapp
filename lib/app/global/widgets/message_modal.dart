import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class MessageModal extends StatelessWidget {
  MessageModal({
    Key? key,
    this.family,
    this.user,
    required this.titulo,
  }) : super(key: key);

  final Family? family;
  final controller = Get.put(MessageController());
  final String? titulo;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              titulo!,
              style: CustomTextStyle.title(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Divider(
              height: 5,
              thickness: 3,
              color: Colors.orange.shade500,
            ),
          ),
          const SizedBox(height: 10),
          Text('Assunto:', style: CustomTextStyle.subtitle(context)),
          TextField(
            controller: controller.subjectController,
            decoration: const InputDecoration(
              hintText: 'Digite o assunto',
            ),
          ),
          const SizedBox(height: 10),
          Text('Mensagem:', style: CustomTextStyle.subtitle(context)),
          TextField(
            controller: controller.messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Digite a mensagem',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child:
                    Text('Cancelar', style: CustomTextStyle.button2(context)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> retorno = <String, dynamic>{};
                  if (user != null) {
                    retorno = await controller.sendMessage(user: user);
                  }
                  if (family != null) {
                    retorno = await controller.sendMessage(family: family);
                  }

                  if (retorno['return'] == 0) {
                    Get.back();
                  }
                  Get.snackbar(
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(milliseconds: 1500),
                    retorno['return'] == 0 ? 'Sucesso' : "Falha",
                    retorno['message'],
                    backgroundColor:
                        retorno['return'] == 0 ? Colors.green : Colors.red,
                    colorText: Colors.white,
                  );
                },
                child: Text(
                  'Enviar',
                  style: CustomTextStyle.button(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
