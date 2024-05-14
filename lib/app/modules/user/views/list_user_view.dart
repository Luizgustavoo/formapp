import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/global/widgets/custom_app_bar.dart';
import 'package:ucif/app/global/widgets/custom_user_card.dart';
import 'package:ucif/app/modules/message/message_controller.dart';
import 'package:ucif/app/modules/user/user_controller.dart';
import 'package:ucif/app/utils/user_storage.dart';

class ListUserView extends GetView<UserController> {
  ListUserView({super.key});
  final box = GetStorage('credenciado');
  final messageController = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    var idUserLogged = box.read('auth')['user']['id'];
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
              await controller.getUsers();
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
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
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
                      'Famílias',
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
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!controller.isLoading.value &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent * 0.9) {
                              controller.loadMoreUsers();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            itemCount: controller.listUsers.length,
                            shrinkWrap: true,
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              User user = controller.listUsers[index];
                              String typeUser = user.tipousuarioId == 1
                                  ? "Master"
                                  : (user.tipousuarioId == 2
                                      ? "Lider"
                                      : "Familiar");
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 600),
                                child: SlideAnimation(
                                  curve: Curves.easeInOut,
                                  child: FadeInAnimation(
                                    child: CustomUserCard(
                                        user: user,
                                        familiaId: UserStorage.getFamilyId(),
                                        idUserLogged: idUserLogged,
                                        controller: controller,
                                        messageController: messageController,
                                        typeUser: typeUser),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: Get.height / 7,
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '35',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.black,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nPessoas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '9',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.blue,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nFamílias',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: '23',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppinss',
                              color: Colors.green,
                              height: 1,
                            ),
                            children: [
                              TextSpan(
                                text: '\nLideranças',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
