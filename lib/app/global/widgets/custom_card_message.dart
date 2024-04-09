// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/models/message_model.dart';
import 'package:ucif/app/global/widgets/aprove_user_modal.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class CustomCardMessage extends StatelessWidget {
  CustomCardMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Message? message;

  final controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    RxBool lida = message!.lida == "sim" ? true.obs : false.obs;
    String? dataCadastro = message?.dataCadastro;
    final List<String> formatMessage = message!.titulo!.split('!?&id=');
    String formattedDate = dataCadastro != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dataCadastro))
        : '';
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              if (formatMessage.length > 1 &&
                  value == true &&
                  message!.solicitacao != 'aprovada') {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  context: context,
                  builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AproveUserModal(
                        idMensagem: message!.id,
                        idAprovacao: int.parse(formatMessage[1]),
                      )),
                );
              } else {
                if (lida.value == false) {
                  controller.changeMessage(
                      message!.id!, UserStorage.getUserId());
                  controller.quantidadeMensagensNaoLidas--;
                  lida.value = true;
                }
              }
            },
            childrenPadding: const EdgeInsets.all(5),
            expandedAlignment: Alignment.centerLeft,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message!.remetenteNome!.toUpperCase(),
                        style: lida.value
                            ? CustomTextStyle.subtitle(context)
                            : CustomTextStyle.subtitleNegrit(context),
                      ),
                      Text(
                        'Assunto: ${formatMessage[0]}'.toUpperCase(),
                        style: lida.value
                            ? CustomTextStyle.subjectMessageRegular(context)
                            : CustomTextStyle.subjectMessageNegrit(context),
                      ),
                      Text(
                        'DATA: $formattedDate',
                        style: lida.value
                            ? CustomTextStyle.dateRegular(context)
                            : CustomTextStyle.dateNegrit(context),
                      ),
                    ],
                  )),
            ),
            children: [
              Text(
                'DESCRIÇÃO: ${message!.descricao}'.toUpperCase(),
                overflow: TextOverflow.clip,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: CustomTextStyle.desc(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
