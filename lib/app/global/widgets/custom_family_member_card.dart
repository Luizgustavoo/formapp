import 'package:flutter/material.dart';
import 'package:ucif/app/data/models/people_model.dart';

class CustomFamilyMemberCard extends StatelessWidget {
  final People people;
  const CustomFamilyMemberCard({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 2),
      child: ListTile(
        title: Text('${people.nome}',
            style: const TextStyle(fontFamily: 'Poppinss')),
      ),
    );
  }
}
