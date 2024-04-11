import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/search_widget.dart';
import 'package:ucif/app/modules/family/family_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class FamilyListModal extends StatelessWidget {
  FamilyListModal({super.key, required this.people});
  final People? people;
  final controller = Get.find<FamilyController>();
  final peopleController = Get.find<PeopleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(190),
      appBar: AppBar(
        title: const Text('Listagem de Famílias'),
      ),
      body: Column(
        children: [
          SearchWidget(
            controller: controller.searchController,
            onSearchPressed: (context, a, query) {
              controller.searchFamily(query);
            },
            onSubmitted: (context, a, query) {
              controller.searchFamily(query);
            },
            isLoading: controller.isLoadingFamilies.value,
          ),
          Expanded(
              child: Obx(
            () => ListView.builder(
              itemCount: controller.listFamilies.length,
              itemBuilder: (context, index) {
                final family = controller.listFamilies[index];
                return Card(
                  color: family.id == people!.familiaId
                      ? Colors.orange
                      : Colors.white,
                  child: ListTile(
                    title: Text(family.nome!,
                        style: CustomTextStyle.subtitleNegrit(context)),
                    subtitle: Text(
                      'Endereço: ${family.endereco}, ${family.cidade}',
                      style: CustomTextStyle.button2(context),
                    ),
                    onTap: () async {
                      if (family.id == people!.familiaId) {
                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(16),
                          contentPadding: const EdgeInsets.all(16),
                          title: "Atenção",
                          titleStyle: CustomTextStyle.titleSplash(context),
                          content: Text(
                            textAlign: TextAlign.center,
                            "${people!.nome} já pertence à ${family.nome}!",
                            style: const TextStyle(
                              fontFamily: 'Poppinss',
                              fontSize: 18,
                            ),
                          ),
                        );
                      } else {
                        showDialog(context, family);
                      }
                    },
                  ),
                );
              },
            ),
          )),
        ],
      ),
    );
  }

  void showDialog(context, Family family) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      titleStyle: CustomTextStyle.titleSplash(context),
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja mudar a ${people!.nome} para a ${family.nome} ?",
        style: const TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancelar",
            style: CustomTextStyle.button2(context),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno = await peopleController
                .changePeopleFamily(family.id!, people!.id!);

            if (retorno['return'] == 0) {
              Get.back();
              Get.back();
            }
            Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(milliseconds: 1500),
              retorno['return'] == 0 ? 'Sucesso' : "Falha",
              retorno['message'],
              backgroundColor:
                  retorno['return'] == 0 ? Colors.green : Colors.red,
              colorText: Colors.white,
            );
          },
          child: Text(
            "Confirmar",
            style: CustomTextStyle.button(context),
          ),
        ),
      ],
    );
  }
}
