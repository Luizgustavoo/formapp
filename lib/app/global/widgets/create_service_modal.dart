import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/service_category_model.dart';
import 'package:ucif/app/modules/people/people_controller.dart'; // O controller que gerencia a lógica
import 'package:ucif/app/utils/custom_text_style.dart';

import '../../data/models/service_model.dart';
import '../../utils/user_storage.dart'; // Estilos personalizados

class CreateAttendanceModal extends StatefulWidget {
  const CreateAttendanceModal({
    Key? key,
    this.atendimento,
    required this.titulo,
    required this.tipoOperacao,
    this.getPeoples = false,
  }) : super(key: key);

  final Atendimento? atendimento;
  final String titulo;
  final String tipoOperacao;
  final bool getPeoples;

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
            Visibility(visible: widget.getPeoples, child: SizedBox(height: 10)),

            Visibility(
              visible: widget.getPeoples,
              child: Obx(() {
                return DropdownSearch<People>(
                  // Mantenha a vinculação
                  selectedItem: controller.selectedPerson.value,
                  itemAsString: (People p) => p.nome ?? '',
                  compareFn: (People item, People selectedItem) =>
                      item.id == selectedItem.id,

                  // Função de busca
                  items: (String filter, LoadProps? loadProps) async {
                    // O segredo do scroll infinito no v6:
                    // O loadProps.skip diz quantos itens já existem na lista do popup
                    final skip = loadProps?.skip ?? 0;
                    final take =
                        20000; // Defina um take fixo ou vindo do loadProps
                    final page = (skip ~/ take) + 1;

                    debugPrint(
                        "🔍 API chamando: Página $page, Filtro '$filter'");

                    return await controller.getPeopleDropdown(
                      filter: filter,
                      page: page,
                      take: take,
                    );
                  },

                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    // IMPORTANTE: Para scroll infinito com API, disableFilter deve ser TRUE
                    // para evitar que o componente tente filtrar localmente o que já veio do banco.
                    disableFilter: true,

                    infiniteScrollProps: const InfiniteScrollProps(
                        // Remova o LoadProps daqui, deixe o widget gerenciar o skip internamente
                        // através da função items
                        ),

                    itemBuilder: (context, item, isSelected, isDisabled) {
                      return ListTile(
                        title: Text(item.nome ?? ''),
                        selected: isSelected,
                      );
                    },
                  ),

                  onChanged: (People? newValue) {
                    controller.selectedPerson.value = newValue;
                  },

                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Selecione uma pessoa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
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

            const SizedBox(height: 10),
            Text('Fotos do Atendimento',
                style: CustomTextStyle.subtitle(context)),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.pickImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.pickImagesFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Obx(() => controller.attendanceImages.isEmpty
                ? const Text('Nenhuma imagem adicionada')
                : SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.attendanceImages.length,
                      itemBuilder: (_, index) {
                        final img = controller.attendanceImages[index];
                        return Stack(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 100,
                                height: 100,
                                child: img.isNew
                                    ? Image.file(img.file!, fit: BoxFit.cover)
                                    : Image.network(
                                        img.url!,
                                        fit: BoxFit.cover,
                                        headers: {
                                          "Authorization":
                                              "Bearer ${UserStorage.getToken()}",
                                        },
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      )),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: GestureDetector(
                                onTap: () => controller.removeAttendanceImage(
                                    index, img.id!),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )),

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
