import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/global/widgets/search_widget.dart';
import 'package:formapp/app/modules/user/user_controller.dart';
import 'package:formapp/app/modules/user/views/create_user_view.dart';
import 'package:formapp/app/utils/custom_text_style.dart';
import 'package:get/get.dart';

class ListUserView extends GetView<UserController> {
  const ListUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Usuários'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  context: context,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Controle de Usuário",
                            style: CustomTextStyle.title(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Divider(
                              height: 5,
                              thickness: 3,
                              color: Colors.orange.shade500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                labelText: 'Nome Completo',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                labelText: 'Login',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.lock),
                                labelText: 'Senha',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'CANCELAR',
                                    style: CustomTextStyle.button2(context),
                                  )),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'SALVAR',
                                    style: CustomTextStyle.button(context),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
              controller: controller.searchController,
              onSearchPressed: (context, a, query) {
                controller.searchUsers(query);
              }),
          Obx(() => Expanded(
                child: ListView.builder(
                    itemCount: controller.listUsers.length,
                    itemBuilder: (context, index) {
                      User user = controller.listUsers[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue, size: 25)),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 25)),
                          title: Text(
                            user.nome!,
                            style: CustomTextStyle.subtitleNegrit(context),
                          ),
                          subtitle: Text(
                            user.username!,
                            style: CustomTextStyle.form(context),
                          ),
                        ),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}
