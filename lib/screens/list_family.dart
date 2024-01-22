import 'package:flutter/material.dart';
import 'package:formapp/models/family_member.dart';
import 'package:formapp/utils/custom_text_style.dart';

class ListFamily extends StatefulWidget {
  final List<FamilyMember> familyMembersList = [];
  ListFamily({super.key});

  @override
  State<ListFamily> createState() => _ListFamilyState();
}

class _ListFamilyState extends State<ListFamily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Famílias Cadastradas'),
      ),
      body: Card(
        color: Colors.orange.shade100,
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'Família: SILVA',
            style: CustomTextStyle.subtitleNegrit(context),
          ),
          subtitle: Text(
            'Endereço: Rua Bem-ti-vi do Brejo, 95',
            style: CustomTextStyle.form(context),
          ),
          children: [
            ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                  Text('Fulano de Tal', style: CustomTextStyle.form(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildListaFamilias() {
  //   return ListView.builder(
  //     itemCount: widget.familyMembersList.length,
  //     itemBuilder: (context, index) {
  //       FamilyMember familyMember = widget.familyMembersList[index];
  //       return Card(
  //         color: Colors.orange.shade200,
  //         child: ListTile(
  //           title: Text('Família: ${familyMember.nomeCompleto}'),
  //           subtitle: Text('Endereço: ${_getEnderecoCompleto(familyMember)}'),
  //           onTap: () {},
  //         ),
  //       );
  //     },
  //   );
  // }

  // String _getEnderecoCompleto(FamilyMember familyMember) {
  //   return '${familyMember.nomeCompleto}, ${familyMember.estadoCivil}';
  // }
}
