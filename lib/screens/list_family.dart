import 'package:flutter/material.dart';
import 'package:formapp/data/models/family_member.dart';
import 'package:formapp/utils/custom_text_style.dart';
import 'package:formapp/widgets/search_widget.dart';

import 'create_family.dart';

class ListFamily extends StatefulWidget {
  final List<FamilyMember> familyMembersList = [];
  ListFamily({super.key});

  @override
  State<ListFamily> createState() => _ListFamilyState();
}

class _ListFamilyState extends State<ListFamily> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Famílias Cadastradas'),
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: _searchController,
              onSearchPressed: (context, a, query) {}),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Card(
              color: Colors.orange.shade100,
              child: ExpansionTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const CreateFamily())));
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.orange.shade700,
                      size: 20,
                    )),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
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
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                        Text('Fulano de Tal',
                            style: CustomTextStyle.form(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
