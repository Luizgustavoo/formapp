// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
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
    // final List<String> formatMessage = message!.titulo!.split('!?&id=');
    String formattedDate = dataCadastro != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dataCadastro))
        : '';
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(left: 0, right: 0, top: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          title: Text(
            message!.titulo!.toUpperCase(),
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 16, color: Colors.black54),
          ),
          subtitle: Text(
            formattedDate,
            style: const TextStyle(
              fontFamily: 'Poppinss',
              fontSize: 15,
            ),
          ),
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              CupertinoIcons.person_2_alt,
              color: Color(0xFF014acb),
            ),
          ),
        ),
      ),
    );
  }
}
