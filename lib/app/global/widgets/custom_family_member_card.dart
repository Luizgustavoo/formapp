import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        onTap: Get.previousRoute == '/detail-people'
            ? null
            : () {
                Get.toNamed('/detail-people', arguments: people);
              },
        trailing: Get.previousRoute == '/detail-people'
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  Get.toNamed('/detail-people', arguments: people);
                },
                icon: const Icon(
                  Icons.remove_red_eye_rounded,
                  size: 20,
                  color: Colors.black54,
                )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${people.nome}',
                style: const TextStyle(fontFamily: 'Poppinss')),
            if (people.provedorCasa == 'sim') ...[
              Text('Provedor: ${people.provedorCasa!.toUpperCase()}',
                  style: const TextStyle(fontFamily: 'Poppinss')),
            ]
          ],
        ),
      ),
    );
  }
}
