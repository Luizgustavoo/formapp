// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/modules/people/people_controller.dart';

import '../../../global/widgets/create_service_modal.dart';
import '../../../utils/user_storage.dart';

class ServicesView extends GetView<PeopleController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime hoje = DateTime.now();
    final DateTime hojeSemHora = DateTime(hoje.year, hoje.month, hoje.day);

    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: controller.selectedPerson.value?.nome ?? '',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearAtendimento();
          //controller.getAllCategories();
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: false,
            context: context,
            builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: CreateAttendanceModal(
                tipoOperacao: 'insert',
                titulo: "Cadastro de Atendimento",
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getServices(controller.selectedPerson.value!.id);
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFf1f5ff),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Atendimentos prestados",
                  style: TextStyle(fontFamily: 'Poppinss', fontSize: 16),
                ),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: Color(0xFF1C6399),
                ),
                const SizedBox(height: 5),

                Obx(
                  () => Expanded(
                    child: controller.isLoadingServices.value == false &&
                            controller.listServices.isEmpty
                        ? const Center(
                            child: Text(
                              'Não há atendimentos para essa pessoa',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              2, // left
                              2, // top
                              2, // right
                              120, // bottom → espaço para o FAB
                            ),
                            itemCount: controller.listServices.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final atendimento =
                                  controller.listServices[index];

                              final dataFormatada = DateFormat(
                                "dd 'de' MMMM 'de' yyyy",
                                'pt_BR',
                              ).format(atendimento.dataAtendimento);

                              final Color colorGreyBlack =
                                  UserStorage.getUserId() !=
                                          atendimento.usuarioId
                                      ? Colors.grey.shade500
                                      : Colors.black;

                              final Color colorGreyWhite =
                                  UserStorage.getUserId() !=
                                          atendimento.usuarioId
                                      ? Colors.grey.shade200
                                      : Colors.white;

                              final Color colorBlue = UserStorage.getUserId() !=
                                      atendimento.usuarioId
                                  ? Colors.blueAccent.shade100
                                  : Colors.blueAccent;

                              final DateTime dataAtendimentoSemHora = DateTime(
                                atendimento.dataAtendimento.year,
                                atendimento.dataAtendimento.month,
                                atendimento.dataAtendimento.day,
                              );

                              Color backgroundDateColor;

                              if (dataAtendimentoSemHora
                                  .isBefore(hojeSemHora)) {
                                backgroundDateColor = Colors.redAccent;
                              } else if (dataAtendimentoSemHora
                                  .isAtSameMomentAs(hojeSemHora)) {
                                backgroundDateColor = Colors.green;
                              } else {
                                backgroundDateColor = Colors.blueAccent;
                              }

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 250),
                                child: SlideAnimation(
                                  verticalOffset: 10,
                                  curve: Curves.easeOut,
                                  child: FadeInAnimation(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: colorGreyWhite,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// Categoria (header)
                                          Text(
                                            atendimento.categoria?.nome ??
                                                'Categoria não informada',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: colorGreyBlack),
                                          ),

                                          const SizedBox(height: 8),

                                          Text(
                                            'Detalhes',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: colorGreyBlack),
                                          ),

                                          /// Observações
                                          Text(
                                            atendimento.observacoes,
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.4,
                                                color: colorGreyBlack),
                                          ),

                                          const SizedBox(height: 10),

                                          if (atendimento
                                              .arquivos.isNotEmpty) ...[
                                            const SizedBox(height: 10),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: atendimento.arquivos
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                final int index = entry.key;
                                                final arquivo = entry.value;

                                                return GestureDetector(
                                                  onTap: () => _abrirGaleria(
                                                      context,
                                                      atendimento.arquivos,
                                                      arquivo),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueGrey.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.blueGrey
                                                              .shade100),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 22,
                                                            color: Colors
                                                                .blueGrey),
                                                        const SizedBox(
                                                            height: 4),
                                                        SizedBox(
                                                          width: 60,
                                                          child: Text(
                                                            "Arquivo ${index + 1}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],

                                          const SizedBox(height: 12),

                                          /// Data e usuário
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: colorGreyBlack,
                                              ),
                                              const SizedBox(width: 6),
                                              SizedBox(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: backgroundDateColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    dataFormatada,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors
                                                          .white, // mantém a cor do texto
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Icon(Icons.person_outline,
                                                  size: 14,
                                                  color: colorGreyBlack),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  atendimento.usuario?.nome ??
                                                      '-',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: colorGreyBlack,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: UserStorage.getUserId() !=
                                                    atendimento.usuarioId
                                                ? Text(
                                                    "Atendimento de \noutro usuário",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: colorBlue,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        tooltip: 'Editar',
                                                        icon: const Icon(
                                                          Icons.edit_outlined,
                                                          size: 20,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        onPressed: () {
                                                          //controller.editAtendimento(atendimento);
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    Padding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets,
                                                              child:
                                                                  CreateAttendanceModal(
                                                                getPeoples:
                                                                    false,
                                                                atendimento:
                                                                    atendimento,
                                                                tipoOperacao:
                                                                    'update',
                                                                titulo:
                                                                    'Editar Atendimento',
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      IconButton(
                                                        tooltip: 'Remover',
                                                        icon: const Icon(
                                                          Icons.delete_outline,
                                                          size: 20,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        onPressed: () async {
                                                          await controller
                                                              .deleteAtendimento(
                                                                  atendimento
                                                                      .id);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                )

                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _abrirGaleria(
      BuildContext context, List arquivos, dynamic arquivoInicial) {
    final PageController pageController = PageController(
      initialPage: arquivos.indexOf(arquivoInicial),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: arquivos.length,
              itemBuilder: (_, index) {
                final img = arquivos[index];

                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      img.url,
                      headers: {
                        "Authorization": "Bearer ${UserStorage.getToken()}"
                      },
                      fit: BoxFit.contain,
                      loadingBuilder: (c, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                );
              },
            ),

            /// Botão fechar
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
