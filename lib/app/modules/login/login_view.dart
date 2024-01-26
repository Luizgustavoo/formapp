import 'package:flutter/material.dart';
import 'package:formapp/app/modules/login/login_controller.dart';
import 'package:formapp/app/screens/family/home_page_family.dart';
import 'package:formapp/app/screens/home_page.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/images/familia.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Colors.white.withAlpha(190),
                      child: Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        constraints: BoxConstraints(maxWidth: size.width),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text("Acessar conta",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                      )),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ToggleSwitch(
                                      initialLabelIndex: 0,
                                      minWidth: 130,
                                      minHeight: 30.0,
                                      cornerRadius: 5.0,
                                      onToggle: (index) =>
                                          controller.onToggle.value = index!,
                                      labels: const ['CREDENCIADO', 'FAMILIAR'],
                                      activeBgColor: [Colors.orange.shade500],
                                      inactiveBgColor: Colors.transparent,
                                      customTextStyles: const [
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppinss',
                                            fontWeight: FontWeight.w900),
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppinss',
                                            fontWeight: FontWeight.w900)
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor digite seu usuário';
                                    }
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value);
                                    if (!emailValid) {
                                      return 'Digite um e-mail válido';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Usuário',
                                    labelStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                    hintText: 'Digite seu usuário...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins',
                                        fontSize: 12),
                                    suffixIcon: const Icon(Icons.email_rounded),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                _gap(),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor digite sua senha';
                                    }

                                    if (value.length < 8) {
                                      return 'A senha deve conter 8 caracteres';
                                    }
                                    return null;
                                  },
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'Senha',
                                      labelStyle: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontFamily: 'Poppins',
                                          fontSize: 14),
                                      hintText: 'Digite sua senha...',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontFamily: 'Poppins',
                                          fontSize: 12),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            controller.isPasswordVisible.value
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                        onPressed: () {
                                          controller.isPasswordVisible.value =
                                              !controller
                                                  .isPasswordVisible.value;
                                        },
                                      )),
                                ),
                                _gap(),
                                CheckboxListTile(
                                  value: controller.rememberMe.value,
                                  onChanged: (value) {
                                    if (value == null) return;
                                    controller.rememberMe.value = value;
                                  },
                                  title: Text(
                                    'Salvar senha',
                                    style: CustomTextStyle.button2(context),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                                _gap(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade500,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Acessar',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (controller.onToggle.value == 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const HomePage())));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const HomePageFamily())));
                                      }
                                      // if (_formKey.currentState?.validate() ??
                                      //     false) {
                                      //   /// do something
                                      // }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
