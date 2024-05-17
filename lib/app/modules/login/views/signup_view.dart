import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/modules/login/login_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class SignUpView extends GetView<LoginController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/images/familia.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.darken))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(top: 30, left: 40),
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: SizedBox(
            //         width: 90,
            //         height: 90,
            //         child: Image(
            //             image: AssetImage('assets/images/logo_splash.png'))),
            //   ),
            // ),
            ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 18, left: 18, right: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.6),
                                blurRadius: 80,
                                spreadRadius: 50,
                              ),
                            ],
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 0,
                            ),
                            child: Form(
                              key: controller.signupKey,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => TextFormField(
                                          controller: controller.nameSignUpCtrl,
                                          enabled:
                                              !controller.isLoggingIn.value,
                                          validator: (value) {
                                            return controller
                                                .validateName(value);
                                          },
                                          decoration: CustomInputDecoration(
                                            hintText: 'Digite seu nome...',
                                            labelText: 'NOME',
                                            suffixIcon:
                                                const Icon(Icons.person),
                                          ),
                                        )),
                                    _gap(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child:
                                              DropdownButtonFormField<String>(
                                            //value: controller.sexo.value,
                                            onChanged: (value) {
                                              //controller.sexo.value = value!;
                                            },
                                            items: [
                                              'Masculino',
                                              'Feminino',
                                              'Não informado'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            decoration: InputDecoration(
                                                labelStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                labelText: 'SEXO'),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: DropdownButtonFormField<int>(
                                            onTap: () async {
                                              await controller
                                                  .getMaritalStatus();
                                            },
                                            value: controller
                                                .estadoCivilSelected.value,
                                            onChanged: (value) {
                                              controller.estadoCivilSelected
                                                  .value = value!;
                                            },
                                            items: controller.listMaritalStatus
                                                .map<DropdownMenuItem<int>>(
                                                    (item) {
                                              return DropdownMenuItem<int>(
                                                value: item.id,
                                                child:
                                                    Text(item.descricao ?? ''),
                                              );
                                            }).toList(),
                                            decoration: InputDecoration(
                                                labelStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                labelText: 'Estado Civil'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _gap(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              maxLength: 10,
                                              // controller: controller.nascimentoPessoaController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: CustomInputDecoration(
                                                  hintText:
                                                      'Digite sua data de nasc...',
                                                  labelText: 'NASCIMENTO',
                                                  suffixIcon: const Icon(Icons
                                                      .calendar_month_rounded))
                                              //onChanged: (value) =>
                                              //  controller.onNascimentoChanged(value),
                                              /* validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !FormattersValidators.validateDateSubmited(
                                      value)) {
                                return 'Data inválida';
                              }
                              return null;
                            },*/
                                              ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              // controller: controller.cpfPessoaController,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 14,
                                              // onChanged: (value) => controller.onCPFChanged(value),
                                              decoration: CustomInputDecoration(
                                                  hintText: 'Digite seu CPF...',
                                                  labelText: 'CPF',
                                                  suffixIcon: const Icon(Icons
                                                      .view_timeline_rounded))),
                                        ),
                                      ],
                                    ),
                                    _gap(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 15,
                                              //  controller: controller.celularPessoaController,
                                              decoration: CustomInputDecoration(
                                                  hintText:
                                                      'Digite seu telefone...',
                                                  labelText: 'TELEFONE',
                                                  suffixIcon:
                                                      const Icon(Icons.phone))
                                              // onChanged: (value) =>
                                              //  controller.onPhoneChanged(value),
                                              ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              // controller: controller.redeSocialPessoaController,
                                              decoration: CustomInputDecoration(
                                                  hintText:
                                                      'Digite seu @ do instagram...',
                                                  labelText: 'REDE SOCIAL',
                                                  suffixIcon: const Icon(
                                                      Icons.alternate_email))),
                                        ),
                                      ],
                                    ),
                                    _gap(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            //controller:
                                            //   controller.tituloEleitoralPessoaController,
                                            keyboardType: TextInputType.number,
                                            maxLength: 12,
                                            decoration: CustomInputDecoration(
                                                hintText:
                                                    'Digite seu título de eleitor...',
                                                labelText: 'TÍTULO ELEITOR',
                                                suffixIcon: const Icon(Icons
                                                    .view_timeline_rounded)),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            //controller: controller.zonaEleitoralPessoaController,
                                            maxLength: 3,
                                            decoration: CustomInputDecoration(
                                                hintText:
                                                    'Digite sua zona eleitoral...',
                                                labelText: 'ZONA ELEITORAL',
                                                suffixIcon:
                                                    const Icon(Icons.adjust)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _gap(),
                                    DropdownButtonFormField<int>(
                                      onTap: () async {
                                        controller.getReligion();
                                      },
                                      value: controller.religiaoSelected.value,
                                      onChanged: (value) {
                                        controller.religiaoSelected.value =
                                            value!;
                                      },
                                      items: controller.listReligion
                                          .map<DropdownMenuItem<int>>((item) {
                                            return DropdownMenuItem<int>(
                                              value: item.id,
                                              child: Text(item.descricao ?? ''),
                                            );
                                          })
                                          .toSet()
                                          .toList(),
                                      decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: 'Religião'),
                                    ),
                                    _gap(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: controller
                                                .igrejaPessoaController,
                                            readOnly: true,
                                            onTap: () async {
                                              final selectedChurch =
                                                  await showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Selecione uma Igreja'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: controller
                                                            .suggestions
                                                            .map(
                                                              (e) => ListTile(
                                                                title: Text(e),
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(e);
                                                                },
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );

                                              if (selectedChurch != null) {
                                                controller
                                                    .igrejaPessoaController
                                                    .text = selectedChurch;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText: 'Igreja',
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                onPressed: () async {
                                                  final selectedChurch =
                                                      await showDialog<String>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Selecione uma Igreja',
                                                        ),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children:
                                                                controller
                                                                    .suggestions
                                                                    .map(
                                                                      (e) =>
                                                                          ListTile(
                                                                        title:
                                                                            Text(
                                                                          e,
                                                                          style:
                                                                              const TextStyle(fontSize: 30),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(e);
                                                                        },
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  if (selectedChurch != null) {
                                                    controller
                                                        .igrejaPessoaController
                                                        .text = selectedChurch;
                                                  }
                                                },
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Selecione uma igreja';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        // Expanded(
                                        //   flex: 2,
                                        //   child:
                                        //       DropdownButtonFormField<String>(
                                        //     onTap: () async {
                                        //       await controller.getChurch();
                                        //     },
                                        //     value: controller
                                        //             .igreja.value.isNotEmpty
                                        //         ? controller.igreja.value
                                        //         : null,
                                        //     hint: const Text(
                                        //         'Selecione uma igreja'),
                                        //     onChanged: (value) {
                                        //       controller.igreja.value = value!;
                                        //     },
                                        //     isExpanded: true,
                                        //     items: controller.listChurch
                                        //         .map<DropdownMenuItem<String>>(
                                        //             (item) {
                                        //       return DropdownMenuItem<String>(
                                        //         value: item.descricao,
                                        //         child:
                                        //             Text(item.descricao ?? ''),
                                        //       );
                                        //     }).toList(),
                                        //     decoration: InputDecoration(
                                        //         labelStyle: const TextStyle(
                                        //           color: Colors.black54,
                                        //           fontFamily: 'Poppins',
                                        //           fontSize: 12,
                                        //         ),
                                        //         border: OutlineInputBorder(
                                        //           borderSide: BorderSide.none,
                                        //           borderRadius:
                                        //               BorderRadius.circular(10),
                                        //         ),
                                        //         labelText: 'Igreja'),
                                        //   ),
                                        // ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                              // controller: controller.funcaoIgrejaPessoaController,
                                              decoration: CustomInputDecoration(
                                                  hintText:
                                                      'Digite sua função na igreja...',
                                                  labelText: 'FUNÇÃO/IGREJA',
                                                  suffixIcon: const Icon(
                                                      Icons.church_rounded))),
                                        ),
                                      ],
                                    ),
                                    _gap(),
                                    TextFormField(
                                        //controller: controller.localTrabalhoPessoaController,
                                        decoration: CustomInputDecoration(
                                            hintText:
                                                'Digite seu local de trabalho...',
                                            labelText: 'LOCAL/TRABALHO',
                                            suffixIcon: const Icon(
                                                Icons.maps_home_work_rounded))),
                                    _gap(),
                                    TextFormField(
                                        // controller: controller.cargoPessoaController,
                                        decoration: CustomInputDecoration(
                                            hintText: 'Digite seu cargo...',
                                            labelText: 'CARGO',
                                            suffixIcon:
                                                const Icon(Icons.work))),
                                    _gap(),
                                    DropdownButtonFormField<String>(
                                      //value: controller.sexo.value,
                                      onChanged: (value) {
                                        //controller.sexo.value = value!;
                                      },
                                      items: [
                                        'Líder 01',
                                        'Líder 02',
                                        'Líder 03'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: 'Liderado'),
                                    ),
                                    _gap(),
                                    Obx(() => TextFormField(
                                        controller:
                                            controller.usernameSignUpCtrl,
                                        validator: (value) {
                                          return controller
                                              .validateUsername(value);
                                        },
                                        enabled: !controller.isLoggingIn.value,
                                        decoration: CustomInputDecoration(
                                            hintText: 'Digite seu e-mail...',
                                            labelText: 'E-MAIL',
                                            suffixIcon:
                                                const Icon(Icons.email)))),
                                    _gap(),
                                    Obx(() => TextFormField(
                                          controller:
                                              controller.passwordSignUpCtrl,
                                          validator: (value) {
                                            return controller.validatePassword(
                                                value, false);
                                          },
                                          enabled:
                                              !controller.isLoggingIn.value,
                                          obscureText: !controller
                                              .isPasswordVisible.value,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                              isDense: true,
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: 'SENHA',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12),
                                              hintText: 'Digite sua senha...',
                                              hintStyle: const TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              suffixIcon: Obx(() => IconButton(
                                                    icon: Icon(
                                                        controller
                                                                .isPasswordVisible
                                                                .value
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        color: Colors.black54),
                                                    onPressed: () {
                                                      controller
                                                              .isPasswordVisible
                                                              .value =
                                                          !controller
                                                              .isPasswordVisible
                                                              .value;
                                                    },
                                                  ))),
                                        )),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: Obx(
                                        () => Visibility(
                                          visible: !controller.loading.value,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                'CADASTRAR',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () async {
                                              Map<String, dynamic> retorno =
                                                  await controller.signUp();

                                              if (retorno['return'] == 0) {
                                                Get.back();
                                              }
                                              Get.snackbar(
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                duration: const Duration(
                                                    milliseconds: 6000),
                                                retorno['return'] == 0
                                                    ? 'Sucesso'
                                                    : "Falha",
                                                retorno['message'],
                                                backgroundColor:
                                                    retorno['return'] == 0
                                                        ? Colors.green
                                                        : Colors.red,
                                                colorText: Colors.white,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => Visibility(
                                        visible: controller.loading.value,
                                        child: Container(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: double.infinity,
                                          height: 70,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            onPressed: null,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Já possui uma conta?',
                                      textAlign: TextAlign.center,
                                      style:
                                          CustomTextStyle.subjectMessageNegrit(
                                              context),
                                    ),
                                    const SizedBox(height: 2),
                                    SizedBox(
                                      height: 50,
                                      child: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'FAZER LOGIN',
                                            style: CustomTextStyle.buttonSignUp(
                                                context),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 5),
                width: size.width,
                height: 70,
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(3, 74, 201, .8)),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Criar conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Poppinss',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 5);
}

class CustomInputDecoration extends InputDecoration {
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final Widget? suffixIcon;

  CustomInputDecoration({
    required this.hintText,
    required this.labelText,
    this.suffixIcon,
  }) : super(
          counterText: "",
          contentPadding: const EdgeInsets.only(left: 10),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        );
}
