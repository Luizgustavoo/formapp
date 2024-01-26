import 'package:flutter/material.dart';
import 'package:formapp/app/utils/custom_text_style.dart';

// ignore: must_be_immutable
class MessageModal extends StatefulWidget {
  bool showWidget;
  MessageModal({
    Key? key,
    this.showWidget = false,
  }) : super(key: key);

  @override
  State<MessageModal> createState() => _MessageModalState();
}

class _MessageModalState extends State<MessageModal> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showWidget
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
          widget.showWidget
              ? Text('Data:', style: CustomTextStyle.subtitle(context))
              : const SizedBox(),
          widget.showWidget
              ? GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
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
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Selecione a data',
                          style: CustomTextStyle.button2(context),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          Text('Assunto:', style: CustomTextStyle.subtitle(context)),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              hintText: 'Digite o assunto',
            ),
          ),
          const SizedBox(height: 10),
          Text('Mensagem:', style: CustomTextStyle.subtitle(context)),
          TextField(
            controller: _messageController,
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
                  Navigator.pop(context);
                },
                child:
                    Text('Cancelar', style: CustomTextStyle.button2(context)),
              ),
              ElevatedButton(
                onPressed: () {
                  // Faça algo com os dados inseridos, por exemplo, enviar a mensagem
                  String subject = _subjectController.text;
                  String message = _messageController.text;

                  // Aqui você pode adicionar a lógica para lidar com o assunto e mensagem
                  print('Assunto: $subject');
                  print('Mensagem: $message');

                  // Fechar o modal
                  Navigator.pop(context);
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
