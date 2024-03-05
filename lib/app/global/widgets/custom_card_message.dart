import 'package:flutter/material.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:intl/intl.dart';

class CustomCardMessage extends StatelessWidget {
  const CustomCardMessage({
    this.title,
    this.date,
    this.desc,
    super.key,
  });

  final String? title;
  final String? desc;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date!);
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.all(5),
            expandedAlignment: Alignment.centerLeft,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assunto: ${title!}'.toUpperCase(),
                    style: CustomTextStyle.subtitleNegrit(context),
                  ),
                  Text(
                    'DATA: $formattedDate',
                    style: CustomTextStyle.date(context),
                  ),
                ],
              ),
            ),
            children: [
              Text(
                'DESCRIÇÃO: ${desc!}'.toUpperCase(),
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
