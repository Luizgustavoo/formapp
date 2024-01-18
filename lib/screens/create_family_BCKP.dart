import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:formapp/widgets/custom_text_style.dart';

class CreateFamily extends StatefulWidget {
  const CreateFamily({super.key});

  @override
  State<CreateFamily> createState() => _CreateFamilyState();
}

class _CreateFamilyState extends State<CreateFamily>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  bool _residenceOwn = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      appBar: AppBar(title: const Text('CADASTRO DE FAMÍLIA')),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 5,
        ),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              margin: const EdgeInsets.all(8),
              elevation: 2,
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'Informações da Família',
                  style: CustomTextStyle.subtitleNegrit(context),
                ),
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 15.0, left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Text(
                          //   'Informações da Família',
                          //   style: CustomTextStyle.subtitle(context),
                          // ),
                          // const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nome da Família',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o nome da família';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              // suffixIcon: IconButton(
                              //     splashRadius: 2,
                              //     iconSize: 20,
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.search_rounded,
                              //     )),
                              labelText: 'CEP',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite o nome da rua';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(width: 5),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Bairro',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o nome da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Complemento',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o número da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Rua',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o nome da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Nº',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o número da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Cidade',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o nome da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'UF',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o número da rua';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _residenceOwn,
                                onChanged: (value) {
                                  setState(() {
                                    _residenceOwn = value ?? false;
                                  });
                                },
                              ),
                              const Text('Residência própria'),
                            ],
                          ),

                          // const SizedBox(height: 20),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: const Text('Enviar'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Composição Familiar',
                    style: CustomTextStyle.subtitleNegrit(context),
                  ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // SizedBox(
                  //     width: 130,
                  //     child: IconButton(
                  //       style: IconButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //         backgroundColor: Colors.orange.shade500,
                  //       ),
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: ((context) =>
                  //                     const CreateFamilyComposition())));
                  //       },
                  //       icon: const Icon(
                  //         Icons.arrow_forward_rounded,
                  //         color: Colors.white,
                  //       ),
                  //     ))
                ],
              ),
            ),
            // const Divider(),
            Expanded(
              child: ListView.builder(
                  itemCount: 30,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Card(
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: const Text('Luiz Gustavo'),
                        children: const [
                          ListTile(
                            leading: Icon(Icons.abc),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      //Init Floating Action Bubble
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionBubble(
          // Menu items
          items: [
            // Floating action menu item
            Bubble(
              title: "Morador",
              iconColor: Colors.white,
              bubbleColor: Colors.orange.shade500,
              icon: Icons.add_rounded,
              titleStyle: const TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'Poppinss'),
              onPress: () {
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Salvar",
              iconColor: Colors.white,
              bubbleColor: Colors.green,
              icon: Icons.save_rounded,
              titleStyle: const TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'Poppinss'),
              onPress: () {
                _animationController.reverse();
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          iconData: Icons.menu_rounded,
          backGroundColor: Colors.orange.shade500,
        ),
      ),
    );
  }
}
