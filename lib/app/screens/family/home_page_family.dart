import 'package:flutter/material.dart';
import 'package:formapp/app/screens/edit_person.dart';
import 'package:formapp/app/screens/family/widgets/custom_drawer_family.dart';
import 'package:formapp/app/global/widgets/custom_person_card.dart';
import 'package:formapp/app/global/widgets/message_modal.dart';

class HomePageFamily extends StatefulWidget {
  const HomePageFamily({super.key});

  @override
  State<HomePageFamily> createState() => _HomePageFamilyState();
}

class _HomePageFamilyState extends State<HomePageFamily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(
        title: const Text('NOME DA FAMILIA'),
      ),
      drawer: const CustomDrawerFamily(),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: const Text(
                  'Composição Familiar',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 5,
                  thickness: 3,
                  color: Colors.orange.shade500,
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return CustomFamilyCard(
                        stripe: index % 2 == 0 ? true : false,
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
                  }))
        ],
      ),
    );
  }
}
