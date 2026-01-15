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
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: '',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearAtendimento();
          controller.getAllCategories();
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

                                          const SizedBox(height: 12),

                                          /// Data e usuário
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: 14,
                                                  color: colorGreyBlack),
                                              const SizedBox(width: 6),
                                              Text(
                                                dataFormatada,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: colorGreyBlack),
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
                                                            builder: (_) =>
                                                                Padding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets,
                                                              child:
                                                                  CreateAttendanceModal(
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
}
