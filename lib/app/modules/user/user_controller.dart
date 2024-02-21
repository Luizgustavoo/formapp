import 'package:flutter/material.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<User> listUsers = <User>[].obs;

  final box = GetStorage('credenciado');
  final repository = Get.find<UserRepository>();

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  @override
  void onClose() {
    getUsers();
    super.onClose();
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      getUsers();
    } else {
      listUsers.assignAll(listUsers
          .where((user) =>
              user.nome!.toLowerCase().contains(query.toLowerCase()) ||
              user.username!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void getUsers() async {
    final token = box.read('auth')['access_token'];

    // ignore: prefer_interpolation_to_compose_strings
    listUsers.value = await repository.getAll("Bearer " + token);
  }
}
