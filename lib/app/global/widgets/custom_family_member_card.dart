import 'package:flutter/material.dart';
import 'package:ucif/app/data/models/people_model.dart';

class CustomFamilyMemberCard extends StatelessWidget {
  final People people;
  const CustomFamilyMemberCard({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            people.family!.nome![0].toUpperCase().toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: Text('Família: ${people.family!.nome.toString()}',
            style: const TextStyle(fontFamily: 'Poppinss')),
      ),
    );
  }
}
