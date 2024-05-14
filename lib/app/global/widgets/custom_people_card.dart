import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/people/views/add_people_family_view.dart';

class CustomPeopleCard extends StatelessWidget {
  const CustomPeopleCard({
    super.key,
    required this.people,
  });

  final People people;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: ListTile(
        onTap: () {
          Get.toNamed('/detail-people', arguments: people);
        },
        dense: true,
        titleAlignment: ListTileTitleAlignment.center,
        leading: CircleAvatar(
          radius: 15,
          backgroundImage: people.foto.toString().isEmpty
              ? const AssetImage('assets/images/default_avatar.jpg')
              : NetworkImage('$urlImagem/storage/app/public/${people.foto}')
                  as ImageProvider,
        ),
        title: Text(people.nome!.toUpperCase(),
            style: const TextStyle(fontFamily: 'Poppinss', fontSize: 11)),
        trailing: IconButton(
            onPressed: () {
              final peopleController = Get.put(PeopleController());
              peopleController.selectedPeople = people;
              peopleController.fillInFieldsForEditPerson();
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                context: context,
                builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: const AddPeopleFamilyView(
                    peopleLocal: false,
                    tipoOperacao: 1,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.edit_note_sharp,
              color: Colors.black54,
            )),
      ),
    );
  }
}
