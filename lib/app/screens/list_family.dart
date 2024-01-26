// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/family_member.dart';
import 'package:formapp/app/screens/create_family.dart';
import 'package:formapp/app/screens/edit_person.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';

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
        title: const Text('Famílias Cadastradas'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const CreateFamily())));
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: _searchController,
              onSearchPressed: (context, a, query) {}),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return CustomFamilyCard(
                      memberName: 'Luiz',
                      memberContact: '43 99928-9380',
                      editMember: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const EditPerson())));
                      },
                      messageMember: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: MessageModal(
                              showWidget: false,
                            ),
                          ),
                        );
                      },
                      supportMember: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: MessageModal(
                              showWidget: true,
                            ),
                          ),
                        );
                      },
                      deleteMember: () {});
                }),
          )
        ],
      ),
    );
  }
}
