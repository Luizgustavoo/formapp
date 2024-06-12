import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucif/app/data/base_url.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';
import 'package:ucif/app/modules/people/people_controller.dart';
import 'package:ucif/app/modules/people/views/add_people_family_view.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/services.dart';
import 'package:ucif/app/utils/user_storage.dart';

class DetailPeopleView extends GetView<PeopleController> {
  const DetailPeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    final People people =
        Get.arguments != null ? Get.arguments as People : People();


    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            showPadding: false,
            title: '',
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFf1f5ff),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 17),
                  Row(
                    mainAxisAlignment: Get.previousRoute == '/member-family'
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (UserStorage.getUserType() != 3) ...[
                        TopCard(
                          onTap: () async {
                            if (await ConnectionStatus.verifyConnection()) {
                              if (people.telefone != null) {
                                controller.whatsapp(people.telefone!);
                              } else {
                                Get.snackbar(
                                    snackPosition: SnackPosition.BOTTOM,
                                    'Falha',
                                    'Telefone não informado!',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red);
                              }
                            } else {
                              Get.snackbar('Falha',
                                  'Verifique sua conexão e tente novamente!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3),
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            }
                          },
                          icon: FontAwesomeIcons.whatsapp,
                          description: 'Conversar\n no whatsapp',
                        ),
                        if (Get.previousRoute == '/member-family') ...[
                          const SizedBox(
                            width: 50,
                          )
                        ],
                        TopCard(
                          onTap: () async {
                            if (await ConnectionStatus.verifyConnection()) {
                              final chatController = Get.put(ChatController());
                              chatController.destinatarioId.value = people.id!;
                              chatController.chatChange();
                              Services.setRoute('/detail-people');
                              Get.toNamed('/chat', arguments: people);
                            } else {
                              Get.snackbar('Falha',
                                  'Verifique sua conexão e tente novamente!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3),
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            }
                          },
                          icon: Icons.wechat_sharp,
                          description: 'Enviar msg\npelo UCIF',
                        ),
                        Get.previousRoute == '/member-family'
                            ? const SizedBox()
                            : TopCard(
                                onTap: () async {
                                  if (await ConnectionStatus
                                      .verifyConnection()) {
                                    controller
                                        .getFamilyMembers(people.family?.id);
                                    Get.toNamed('/member-family');
                                  } else {
                                    Get.snackbar('Falha',
                                        'Verifique sua conexão e tente novamente!',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 3),
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red);
                                  }
                                },
                                icon: Icons.groups_2,
                                description: 'Ver membros\nda família',
                              ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 5,
                    thickness: 2,
                    color: Color(0xFF1C6399),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormattedText(
                                text:
                                    'Líder: ${people.peopleLocal! ? UserStorage.getUserName() : people.user?.nome}'),
                            const SizedBox(height: 15),
                            FormattedText(
                                text: 'Provedor: ${people.provedorCasa}'),
                            FormattedText(text: 'Sexo: ${people.sexo}'),

                            FormattedText(
                                text:
                                    'Estado Civil: ${people.peopleLocal! ? people.estado_civil_name : people.maritalStatus?.descricao}'),
                            FormattedText(
                                text: 'Nascimento: ${people.dataNascimento}', local: true,),
                            FormattedText(
                                text: 'Parentesco: ${people.parentesco}'),
                            FormattedText(text: 'CPF: ${people.cpf}'),
                            FormattedText(text: 'Telefone: ${people.telefone}'),
                            FormattedText(
                                text: 'Rede Social: @${people.redeSocial}'),
                            const SizedBox(height: 15),
                            people.peopleLocal == true
                                ? FormattedText(
                                    text:
                                        'Problemas de Saúde: ${people.acometimentosOfflineNames}',
                                  )
                                : people.acometimentosSaude != null &&
                                        people.acometimentosSaude!.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            FormattedText(
                                              text:
                                                  'Problemas de Saúde: ${people.acometimentosSaude!.map((acomentimento) => acomentimento.nome).join(', ')}',
                                            ),
                                          ])
                                    : FormattedText(
                                        text:
                                            'Problemas de Saúde: Nenhum problema informado.',
                                      ),
                            people.peopleLocal == true
                                ? FormattedText(
                                    text:
                                        'Medicamento: ${people.medicamentosOfflineNames}',
                                  )
                                : people.medicamentos != null &&
                                        people.medicamentos!.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            FormattedText(
                                              text:
                                                  'Medicamento: ${people.medicamentos!.map((medicamento) => medicamento.nome).join(', ')}',
                                            ),
                                          ])
                                    : FormattedText(
                                        text:
                                            'Medicamentos: Nenhum medicamento informado.',
                                      ),
                            const SizedBox(height: 15),
                            FormattedText(
                                text:
                                    'Religião: ${people.peopleLocal! ? people.religiao_name : people.religion?.descricao}'),
                            FormattedText(text: 'Igreja: ${people.igrejaId}'),
                            FormattedText(
                                text: 'Função Igreja: ${people.funcaoIgreja}'),
                            const SizedBox(height: 15),
                            FormattedText(
                                text:
                                    'Local de Trabalho: ${people.localTrabalho}'),
                            FormattedText(
                                text: 'Cargo: ${people.cargoTrabalho}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {

                            final peopleController =
                                Get.put(PeopleController());
                            peopleController.getMaritalStatus();
                            peopleController.getChurch();
                            peopleController.getReligion();
                            peopleController.getHealth();
                            peopleController.getMedicine();
                            peopleController.selectedPeople = people;
                            peopleController.fillInFieldsForEditPerson();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: AddPeopleFamilyView(
                                  peopleLocal: people.peopleLocal!,
                                  tipoOperacao: 1,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'EDITAR',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppinss'),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height -
                  CustomAppBar().preferredSize.height) *
              .180,
          left: 15,
          right: 15,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 15, bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: people.foto.toString().isEmpty
                              ? const AssetImage(
                                  'assets/images/default_avatar.jpg')
                              : NetworkImage(
                                      '$urlImagem/storage/app/public/${people.foto}')
                                  as ImageProvider,
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * 0.55,
                          child: Text(
                            people.nome!.toUpperCase(),
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                overflow: TextOverflow.clip,
                                fontFamily: 'Poppinss',
                                fontSize: 12),
                          ),
                        ),
                        Text(
                          'ID: ${people.id}',
                          style: const TextStyle(
                              fontFamily: 'Poppinss',
                              fontSize: 12,
                              color: Color(0xFF1C6399)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormattedText extends StatelessWidget {
  final String text;
  bool? local = false;

  FormattedText({Key? key, required this.text, this.local}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = text.split(':');
    if (parts.length != 2) {
      return Text(text);
    }

    final boldPart = parts[0].trim();
    final normalPart = parts[1].trim();

    // Verifica se o normalPart é uma data de nascimento
    if (boldPart.toLowerCase() == 'nascimento' && normalPart.isNotEmpty) {
      // Formata a data de nascimento usando DateFormat
      try {
        String formattedDate = "";

        if(local!){
          formattedDate = normalPart;
        }else{
          final DateTime birthDate = DateFormat("yyyy-MM-dd").parse(normalPart);
          formattedDate = DateFormat("dd/MM/yyyy").format(birthDate);
        }



        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$boldPart: ',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: formattedDate,
                style: const TextStyle(
                  fontFamily: 'Poppinss',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$boldPart: ${e}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: 'Não informado',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$boldPart: ',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: normalPart == 'null' ? 'Não informado' : normalPart,
            style: const TextStyle(
              fontFamily: 'Poppinss',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  final Function()? onTap;
  final IconData? icon;
  final String? description;
  const TopCard(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Card(
            elevation: 1,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                size: 30,
                color: const Color(0xFF1C6399),
              ),
            ),
          ),
        ),
        Text(
          description!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppinss', fontSize: 11),
        )
      ],
    );
  }
}
