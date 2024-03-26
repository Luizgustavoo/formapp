import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class MessageServiceModal extends StatelessWidget {
  MessageServiceModal(
      {Key? key,
      required this.showWidget,
      this.family,
      this.people,
      this.tipoOperacao = 'insert',
      required this.titulo,
      this.familyService})
      : super(key: key);

  final bool showWidget;
  final Family? family;
  final FamilyController controller = Get.find();
  final PeopleController peopleController = Get.find();
  final People? people;
  final String tipoOperacao;
  final FamilyService? familyService;
  final String? titulo;

  @override
  Widget build(BuildContext context) {
    final familiaId = controller.box.read('auth')['user']['familia_id'];
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          showWidget
              ? Text(
                  titulo!,
                  style: CustomTextStyle.title(context),
                )
              : Text(
                  titulo!,
                  style: CustomTextStyle.title(context),
                ),
          const Padding(
            padding: EdgeInsets.only(right: 5, bottom: 10),
            child: Divider(
              height: 5,
              thickness: 3,
              color: Color(0xFF1C6399),
            ),
          ),
          showWidget
              ? Text('Data:', style: CustomTextStyle.subtitle(context))
              : const SizedBox(),
          showWidget
              ? GestureDetector(
                  onTap: familiaId == null
                      ? () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null &&
                              pickedDate !=
                                  peopleController.selectedDate.value) {
                            peopleController.selectedDate.value = pickedDate;
                          }
                        }
                      : null,
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
                          if (peopleController.selectedDate.value != null) {
                            return Text(
                              '${peopleController.selectedDate.value!.day}/${peopleController.selectedDate.value!.month}/${peopleController.selectedDate.value!.year}',
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
            controller: peopleController.subjectController,
            enabled: familiaId == null,
            decoration: const InputDecoration(
              hintText: 'Digite o assunto',
            ),
          ),
          const SizedBox(height: 10),
          Text('Mensagem:', style: CustomTextStyle.subtitle(context)),
          TextField(
            enabled: familiaId == null,
            controller: peopleController.messageController,
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
              if (familiaId == null) ...[
                ElevatedButton(
                  onPressed: () async {
                    // if (peopleController.selectedDate.value != null) {
                    //   String data =
                    //       "${peopleController.selectedDate.value!.year.toString().padLeft(4, '0')}-"
                    //       "${peopleController.selectedDate.value!.month.toString().padLeft(2, '0')}-"
                    //       "${peopleController.selectedDate.value!.day.toString().padLeft(2, '0')}";
                    //   print('Dataaa: $data');
                    // }
                    List<People> pessoas = [];
                    Family? family2;
                    if (family == null) {
                      pessoas.add(people!);
                      family2 = Family(pessoas: pessoas);
                    }

                    Map<String, dynamic> retorno = tipoOperacao == 'insert'
                        ? family != null
                            ? await peopleController.saveService(family!)
                            : await peopleController.saveService(family2!)
                        : await peopleController
                            .updateService(familyService!.id!);

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
              ]
            ],
          ),
        ],
      ),
    );
  }
}
