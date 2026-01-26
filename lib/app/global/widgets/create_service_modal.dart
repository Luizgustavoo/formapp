import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/service_category_model.dart';
import 'package:ucif/app/modules/people/people_controller.dart'; // O controller que gerencia a lógica
import 'package:ucif/app/utils/custom_text_style.dart';

import '../../data/models/service_model.dart'; // Estilos personalizados

class CreateAttendanceModal extends StatefulWidget {
  const CreateAttendanceModal({
    Key? key,
    this.atendimento,
    required this.titulo,
    required this.tipoOperacao,
  }) : super(key: key);

  final Atendimento? atendimento;
  final String titulo;
  final String tipoOperacao;

  @override
  State<CreateAttendanceModal> createState() => _CreateAttendanceModalState();
}

class _CreateAttendanceModalState extends State<CreateAttendanceModal> {
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
      controller.setAttendanceDate(picked);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initAttendanceForm(
        tipoOperacao: widget.tipoOperacao,
        atendimento: widget.atendimento,
      );
    });
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
              widget.titulo ?? '',
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

            TextFormField(
              readOnly: true,
              controller: controller.attendanceDateController,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Data de Atendimento',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              validator: (_) {
                if (controller.attendanceDate.value == null) {
                  return 'Por favor, selecione a data';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

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

            // --- Data de Atendimento (data_atendimento) ---

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
                        Map<String, dynamic> retorno =
                            widget.tipoOperacao == 'insert'
                                ? await controller.saveAtendimento()
                                : await controller
                                    .updateAtendimento(widget.atendimento!.id);

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
                      widget.tipoOperacao == 'insert' ? 'SALVAR' : 'ALTERAR',
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
