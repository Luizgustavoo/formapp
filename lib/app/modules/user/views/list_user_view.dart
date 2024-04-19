import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/global/shimmer/shimmer_custom_user_card.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_user_card.dart';
import 'package:ucif/app/global/widgets/search_widget.dart';
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
    var idUserLogged = box.read('auth')['user']['id'];
    controller.getUsers();
    return Scaffold(
      appBar: CustomAppBar(
        showPadding: false,
        title: 'Usuários',
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            topEnd: Radius.circular(15),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.searchController.clear();
            Get.offAllNamed('/list-user');
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchWidget(
                controller: controller.searchController,
                onSearchPressed: (context, a, query) {
                  controller.getUsers(search: controller.searchController.text);
                },
                onSubmitted: (context, a, query) {
                  controller.getUsers(search: controller.searchController.text);
                },
                isLoading: controller.isLoading.value,
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isLoading.value &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.9) {
                      controller.loadMoreUsers();
                    }
                    return false;
                  },
                  child: Obx(() {
                    final status = Get.find<InternetStatusProvider>().status;

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
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return const ShimmerCustomUserCard();
                              },
                            )
                          : AnimationLimiter(
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.listUsers.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  User user = controller.listUsers[index];

                                  String typeUser = user.tipousuarioId == 1
                                      ? "Master"
                                      : (user.tipousuarioId == 2
                                          ? "Lider"
                                          : "Familiar");

                                  bool desativaMaster =
                                      UserStorage.getUserType() == 1;
                                  bool desativaLider =
                                      UserStorage.getUserType() == 1 ||
                                          user.id == UserStorage.getUserId();
                                  bool desativaFamiliar =
                                      user.id == UserStorage.getUserId() ||
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
                                      confirmDismiss:
                                          (DismissDirection direction) async {
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
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  user.status == 1
                                                      ? const Icon(
                                                          Icons.delete_outline,
                                                          color: Colors.white,
                                                          size: 25)
                                                      : const Icon(
                                                          Icons.check_rounded,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child:
                                          AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 600),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          curve: Curves.easeInOut,
                                          child: FadeInAnimation(
                                            child: CustomUserCard(
                                                user: user,
                                                familiaId:
                                                    UserStorage.getFamilyId(),
                                                idUserLogged: idUserLogged,
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
            ],
          ),
        ),
      ),
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
