import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

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
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null &&
                        pickedDate != peopleController.selectedDate.value) {
                      peopleController.selectedDate.value = pickedDate;
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
            decoration: const InputDecoration(
              hintText: 'Digite o assunto',
            ),
          ),
          const SizedBox(height: 10),
          Text('Mensagem:', style: CustomTextStyle.subtitle(context)),
          TextField(
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
              ElevatedButton(
                onPressed: () async {
                  if (peopleController.selectedDate.value != null) {
                    String data =
                        "${peopleController.selectedDate.value!.year.toString().padLeft(4, '0')}-"
                        "${peopleController.selectedDate.value!.month.toString().padLeft(2, '0')}-"
                        "${peopleController.selectedDate.value!.day.toString().padLeft(2, '0')}";
                    print('Dataaa: $data');
                  }
                  if (family != null) {
                    peopleController.idFamilySelected = family!.id!;
                  }
                  if (people != null) {
                    peopleController.idPeopleSelected = people!.id!;
                  }
                  Map<String, dynamic> retorno = <String, dynamic>{};

                  if (peopleController.idPeopleSelected != null) {
                    retorno = tipoOperacao == 'insert'
                        ? await peopleController.saveService()
                        : await peopleController
                            .updateService(familyService!.id!);
                  } else {
                    //salvar atendimento familia
                  }

                  Get.back();

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
