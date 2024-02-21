import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class MessageServicePage extends StatelessWidget {
  MessageServicePage({Key? key, required this.showWidget, this.family})
      : super(key: key);

  final bool showWidget;
  final Family? family;
  FamilyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          showWidget
              ? Text(
                  'Atendimento',
                  style: CustomTextStyle.title(context),
                )
              : Text(
                  'Mensagem',
                  style: CustomTextStyle.title(context),
                ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Divider(
              height: 5,
              thickness: 3,
              color: Colors.orange.shade500,
            ),
          ),
          showWidget
              ? Text('Data:', style: CustomTextStyle.subtitle(context))
              : const SizedBox(),
          showWidget
              ? GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (pickedDate != null &&
                        pickedDate != controller.selectedDate.value) {
                      controller.selectedDate.value = pickedDate;
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.orange.shade700,
                        ),
                        Obx(() {
                          if (controller.selectedDate.value != null) {
                            return Text(
                              '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                              style: CustomTextStyle.button2(context),
                            );
                          } else {
                            return Text(
                              'Selecione a data',
                              style: CustomTextStyle.button2(context),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
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
            maxLines: 3,
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
                onPressed: () {
                  String subject = controller.subjectController.text;
                  String message = controller.messageController.text;

                  if (controller.selectedDate.value != null) {
                    String dia = controller.selectedDate.value!.day
                        .toString()
                        .padLeft(2, '0');
                    String mes = controller.selectedDate.value!.month
                        .toString()
                        .padLeft(2, '0');
                    String ano = controller.selectedDate.value!.year
                        .toString()
                        .padLeft(4, '0');

                    String data = "$ano-$mes-$dia";
                    print('Dataaa: $data');
                  }

                  print('Assunto: $subject');
                  print('Mensagem: $message');

                  print(family!.nome!); // Fechar o modal
                  Get.back();
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
