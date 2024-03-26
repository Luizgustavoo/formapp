import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key, this.userName, this.showPadding}) : super(key: key);
  final String? userName;
  final bool? showPadding;

  @override
  Size get preferredSize {
    double factor = 0.2; // Ajuste esse fator conforme necessário
    if (showPadding == false) {
      factor = 0.15; // Ajuste esse fator conforme necessário
    }
    return Size.fromHeight(Get.height * factor);
  }

  final messageController = Get.put(MessageController());
  final userController = Get.put(UserController());
  final RxString greeting = ''.obs;

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    greeting.value = getGreeting(currentTime);
    messageController.getMessages();

    ever(greeting, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.forceAppUpdate();
      });
    });

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: showPadding == false
                ? const EdgeInsets.only(right: 20, top: 60)
                : const EdgeInsets.only(left: 20, right: 20, top: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    showPadding == false
                        ? IconButton(
                            onPressed: () {
                              Get.offAllNamed('/home');
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ))
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/logo_horizontal.png',
                      width: Get.width * 0.25,
                      height: Get.height * 0.1,
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.toNamed('/list-message');
                          },
                          icon: const Icon(
                            Icons.sms,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Obx(() => Positioned(
                              right: 0,
                              top: 0,
                              child: messageController
                                          .quantidadeMensagensNaoLidas.value >
                                      0
                                  ? badges.Badge(
                                      showBadge: true,
                                      ignorePointer: false,
                                      onTap: () {},
                                      badgeContent: const Icon(Icons.check,
                                          color: Colors.white, size: 10),
                                      badgeAnimation:
                                          const badges.BadgeAnimation.rotation(
                                        animationDuration: Duration(seconds: 1),
                                        colorChangeAnimationDuration:
                                            Duration(seconds: 1),
                                        loopAnimation: false,
                                        curve: Curves.easeInOut,
                                      ),
                                    )
                                  : const SizedBox(),
                            ))
                      ],
                    ),
                    if (ModalRoute.of(context)!.settings.name != '/perfil')
                      IconButton(
                        onPressed: () {
                          userController.fillInPerfilFields();
                          Get.toNamed('/perfil');
                        },
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (showPadding!)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8, right: 20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Olá, $userName ',
                              style: CustomTextStyle.appBarTitle(context)),
                          const HandWaveAnimation(),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('$greeting, seja bem vindo!',
                              style: CustomTextStyle.appBarSubtitle(context)),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String getGreeting(DateTime currentTime) {
    String greeting = '';

    if (currentTime.hour < 12) {
      greeting = 'Bom dia';
    } else if (currentTime.hour < 18) {
      greeting = 'Boa tarde';
    } else {
      greeting = 'Boa noite';
    }

    return greeting;
  }
}

class HandWaveAnimation extends StatefulWidget {
  const HandWaveAnimation({super.key});

  @override
  State<HandWaveAnimation> createState() => _HandWaveAnimationState();
}

class _HandWaveAnimationState extends State<HandWaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.08).animate(_controller),
      child: const Text(
        '👋',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
