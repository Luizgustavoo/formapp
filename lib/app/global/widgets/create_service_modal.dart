import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import 'package:ucif/app/data/models/people_model.dart'; // Importe conforme o seu código
import 'package:ucif/app/data/models/service_category_model.dart';
import 'package:ucif/app/modules/people/people_controller.dart'; // O controller que gerencia a lógica
import 'package:ucif/app/utils/custom_text_style.dart'; // Estilos personalizados

class CreateAttendanceModal extends StatelessWidget {
  CreateAttendanceModal({
    Key? key,
    this.people,
    required this.titulo,
    required this.tipoOperacao,
  }) : super(key: key);

  final People? people; // Talvez seja a pessoa que está sendo atendida
  final String? titulo;
  final String? tipoOperacao;

  // Assumindo que a PeopleController agora gerencia a lógica de Atendimento
  final PeopleController controller = Get.find();

  // Função para abrir o DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.attendanceDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'), // Adapte a localização, se necessário
    );
    if (picked != null) {
      controller.attendanceDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.serviceFormKey, // Reutilizando a key, você pode renomear
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titulo!,
              style: CustomTextStyle.title(context),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Divider(
                height: 5,
                thickness: 3,
                color: Color(0xFF1C6399),
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            // --- Seleção de Categoria (categoria_id) ---
            Obx(
              () => DropdownButtonFormField<CategoriaAtendimento>(
                isDense: true,
                menuMaxHeight: Get.size.height / 2,
                value: controller.selectedCategory.value,
                hint: const Text('Selecione a Categoria'),
                onChanged: (CategoriaAtendimento? newValue) {
                  controller.selectedCategory.value = newValue;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
                items: controller.listCategoriasAtendimento.value
                    .map<DropdownMenuItem<CategoriaAtendimento>>(
                        (CategoriaAtendimento category) {
                  return DropdownMenuItem<CategoriaAtendimento>(
                    value: category,
                    child: Text(category.nome),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Categoria'),
              ),
            ),
            const SizedBox(height: 10),

            // --- Seleção de Pessoa (pessoa_id) ---
            Obx(
              () => DropdownButtonFormField<People>(
                isDense: true,
                menuMaxHeight: Get.size.height / 2,
                value: controller.selectedPerson.value,
                hint: const Text('Selecione um familiar'),
                onChanged: (People? newValue) {
                  controller.selectedPerson.value = newValue;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um familiar';
                  }
                  return null;
                },
                items: controller.listPeoplesDropDown.value
                    .map<DropdownMenuItem<People>>((People person) {
                  return DropdownMenuItem<People>(
                    value: person,
                    child: Text(person.nome ?? 'Sem nome'),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Familiar'),
              ),
            ),
            const SizedBox(height: 10),

            // --- Data de Atendimento (data_atendimento) ---
            Obx(
              () => TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: controller.attendanceDate.value == null
                      ? ''
                      : DateFormat('dd/MM/yyyy')
                          .format(controller.attendanceDate.value!),
                ),
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'Data de Atendimento',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (controller.attendanceDate.value == null) {
                    return 'Por favor, selecione a data';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),

            // --- Observações (observacoes) ---
            TextFormField(
              controller: controller
                  .notesController, // Usar um novo controller no PeopleController
              maxLines: 4, // Permite múltiplas linhas para um "textarea"
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Observações',
                alignLabelWithHint: true, // Alinha o label no topo
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // --- Botões ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'CANCELAR',
                      style: CustomTextStyle.button2(context),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      // **Lógica de Validação e Salvar Atendimento**
                      if (controller.serviceFormKey.currentState!.validate()) {
                        Map<String, dynamic> retorno = tipoOperacao == 'insert'
                            ? await controller.saveAtendimento()
                            : await controller.saveAtendimento();

                        if (retorno['return'] == 0) {
                          Get.back();
                        }
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 1500),
                          retorno['return'] == 0 ? 'Sucesso' : "Falha",
                          retorno['message'],
                          backgroundColor: retorno['return'] == 0
                              ? Colors.green
                              : Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text(
                      tipoOperacao == 'insert' ? 'SALVAR' : 'ALTERAR',
                      style: CustomTextStyle.button(context),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
