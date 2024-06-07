import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_user_card.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_dynamic_rich_text.dart';
import 'package:ucif/app/global/widgets/custom_user_card.dart';
import 'package:ucif/app/modules/home/home_controller.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/custom_text_style.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ListUserView extends GetView<UserController> {
  ListUserView({super.key});
  final box = GetStorage('credenciado');
  final messageController = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    var idUserLogged = box.read('auth')['user']['id'];
    double previousScrollPosition = 0.0;
    Timer? _debounce;

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            showPadding: false,
            title: '',
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              controller.searchController.clear();
              Get.offAllNamed('/list-user');
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFf1f5ff),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / (UserStorage.getUserType() == 3 ? 30 : 15)),
                    SizedBox(
                      height: 35,
                      child: TextField(
                        controller: controller.searchController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (query) {
                          controller.getUsers(
                              search: controller.searchController.text
                                  .toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Encontre um cadastrado ...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppinss',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.getUsers(
                                  search: controller.searchController.text);
                            },
                            icon: const Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lideranças',
                      style: TextStyle(fontFamily: 'Poppinss', fontSize: 16),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 2,
                      color: Color(0xFF1C6399),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(


                      onNotification: (ScrollNotification scrollInfo) {
                      if (!controller.isLoading.value &&
                      scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                      if (scrollInfo.metrics.pixels > previousScrollPosition) {
                      // Se o usuário está rolando para baixo, chama a função loadMoreUsers()

                        if (scrollInfo.metrics.pixels > previousScrollPosition) {
                          // Se o usuário está rolando para baixo, chama a função loadMoreUsers()
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 300), () {
                            controller.loadMoreUsers();
                          });
                        }

                      }
                      }
                      previousScrollPosition = scrollInfo.metrics.pixels;
                      return false;
                      },
                        child: Obx(() {
                          final status =
                              Get.find<InternetStatusProvider>().status;

                          if (status == InternetStatus.disconnected) {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return const ShimmerCustomUserCard();
                              },
                            );
                          } else {
                            return controller.isLoading.value
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: 15,
                                    itemBuilder: (context, index) {
                                      return const ShimmerCustomUserCard();
                                    },
                                  )
                                : AnimationLimiter(
                                    child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.listUsers.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        User user = controller.listUsers[index];

                                        String typeUser =
                                            user.tipousuarioId == 1
                                                ? "Master"
                                                : (user.tipousuarioId == 2
                                                    ? "Lider"
                                                    : "Familiar");

                                        bool desativaMaster =
                                            UserStorage.getUserType() == 1;
                                        bool desativaLider =
                                            UserStorage.getUserType() == 1 ||
                                                user.id ==
                                                    UserStorage.getUserId();
                                        bool desativaFamiliar = user.id ==
                                                UserStorage.getUserId() ||
                                            desativaMaster ||
                                            desativaLider;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, bottom: 5),
                                          child: Dismissible(
                                            key: UniqueKey(),
                                            direction: (!desativaMaster &&
                                                    !desativaLider &&
                                                    !desativaFamiliar)
                                                ? DismissDirection.none
                                                : DismissDirection.endToStart,
                                            confirmDismiss: (DismissDirection
                                                direction) async {
                                              if (direction ==
                                                  DismissDirection.endToStart) {
                                                showDialog(context, user);
                                              }
                                              return false;
                                            },
                                            background: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: user.status == 1
                                                    ? Colors.red.shade500
                                                    : Colors.green,
                                              ),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        user.status == 1
                                                            ? const Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 25)
                                                            : const Icon(
                                                                Icons
                                                                    .check_rounded,
                                                                size: 25,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              child: SlideAnimation(
                                                verticalOffset: 50.0,
                                                curve: Curves.easeInOut,
                                                child: FadeInAnimation(
                                                  child: CustomUserCard(
                                                      user: user,
                                                      familiaId: UserStorage
                                                          .getFamilyId(),
                                                      idUserLogged:
                                                          idUserLogged,
                                                      controller: controller,
                                                      messageController:
                                                          messageController,
                                                      typeUser: typeUser),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          }
                        }),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ),
        ),
        if(UserStorage.getUserType() < 3)...[
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
                      right: 10, left: 10, top: 15, bottom: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DynamicRichText(
                            routeR: '/list-people',
                            value: homeController.counter2,
                            description: 'Pessoas',
                            valueStyle: const TextStyle(
                              fontFamily: 'Poppinss',
                            ),
                            descriptionStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            color: Colors.black,
                          ),
                          DynamicRichText(
                            routeR: '/list-family',
                            value: homeController.counter,
                            description: 'Famílias',
                            valueStyle: const TextStyle(
                              fontFamily: 'Poppinss',
                              height: 1,
                            ),
                            descriptionStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                            color: Colors.blue,
                          ),
                          DynamicRichText(
                            routeR: '/list-user',
                            value: homeController.counter3,
                            description: 'Lideranças',
                            valueStyle: const TextStyle(
                              fontFamily: 'Poppinss',
                              height: 1,
                            ),
                            descriptionStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  void showDialog(context, User user) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        user.status == 0
            ? "Tem certeza que deseja ativar novamente o usuário ${user.nome} ?"
            : "Tem certeza que deseja desativar o usuário ${user.nome} ?",
        style: const TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno = user.status == 0
                ? await controller.deleteUser(user.id!, 1)
                : await controller.deleteUser(user.id!, 0);
            if (retorno['return'] == 0) {
              Get.back();
            }
            Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(milliseconds: 1500),
              retorno['return'] == 0 ? 'Sucesso' : "Falha",
              retorno['message'],
              backgroundColor:
                  retorno['return'] == 0 ? Colors.green : Colors.red,
              colorText: Colors.white,
            );
          },
          child: Text(
            "Confirmar",
            style: CustomTextStyle.button(context),
          ),
        ),
      ],
    );
  }
}
