import 'package:flutter/material.dart';
import 'package:formapp/app/modules/family/family_controller.dart';
import 'package:get/get.dart';

class FamilyListModal extends StatelessWidget {
  final FamilyController controller = Get.find<FamilyController>();

  FamilyListModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Famílias'),
      ),
      body: ListView.builder(
        itemCount: controller.listFamilies.length,
        itemBuilder: (context, index) {
          final family = controller.listFamilies[index];
          return ListTile(
            title: Text(family.nome!),
            subtitle: Text('Endereço: ${family.endereco}, ${family.cidade}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
