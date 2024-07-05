// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/models/message_model.dart';

class CustomCardMessage extends StatelessWidget {
  const CustomCardMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final Message? message;

  @override
  Widget build(BuildContext context) {
    String? dataCadastro = message?.dataCadastro;
    String formattedDate = dataCadastro != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dataCadastro))
        : '';
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(10.0),
        tilePadding: const EdgeInsets.all(8),
        title: const Text('NOTIFICAÇÃO'),
        subtitle: Text(
          formattedDate,
          style: const TextStyle(
            fontFamily: 'Poppinss',
            fontSize: 15,
          ),
        ),
        children: [
          Text(
            message!.titulo!.toUpperCase(),
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
