import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int onToggle = 0;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
                      color: Colors.white.withAlpha(220),
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
                                _gap2(),
                                TextFormField(
                                  validator: (value) {
                                    // add email validation
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
                                  obscureText: !_isPasswordVisible,
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
                                        icon: Icon(_isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      )),
                                ),
                                _gap(),
                                CheckboxListTile(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _rememberMe = value;
                                    });
                                  },
                                  title: const Text('Salvar senha'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                ),
                                _gap(),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 13),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //     children: [
                                //       ToggleSwitch(
                                //         initialLabelIndex: 0,
                                //         activeFgColor: Colors.white,
                                //         minWidth: 130.0,
                                //         minHeight: 38.0,
                                //         cornerRadius: 10.0,
                                //         onToggle: (index) =>
                                //             onToggle = index!,
                                //         labels: const [
                                //           'CREDENCIADO',
                                //           'FAMILIAR'
                                //         ],
                                //         inactiveBgColor: Colors.transparent,
                                //         activeBgColor: [
                                //           Colors.orange.shade500,
                                //         ],
                                //         customTextStyles: const [
                                //           TextStyle(
                                //             color: Colors.black87,
                                //             fontSize: 14.0,
                                //             fontFamily: 'Poppins',
                                //           ),
                                //           TextStyle(
                                //             color: Colors.black87,
                                //             fontSize: 14.0,
                                //             fontFamily: 'Poppins',
                                //           )
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // _gap(),
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
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        /// do something
                                      }
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
  Widget _gap2() => const SizedBox(height: 32);
}
