import 'dart:io';

import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/user_provider.dart';
import 'package:formapp/app/utils/connection_service.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getAll(String token, {int? page}) async {
    List<User> list = <User>[];

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token, page: page);
      List<User> newUsers = [];
      response['data'].forEach((e) {
        User u = User.fromJson(e);
        newUsers.add(u);
      });
      if (page == 1) {
        list.clear();
      }
      for (var family in newUsers) {
        if (!list.contains(family)) {
          list.add(family);
        }
      }
    }
    return list;
  }

  insertUser(String token, User user) async {
    try {
      var response = await apiClient.insertUser(token, user);

      return response;
    } catch (e) {
      throw Exception('Erro ao inserir a usuário: $e');
    }
  }

  updateUser(
      String token, User user, File? imageFile, String? oldImagePath) async {
    try {
      var response = await apiClient.updateUser(
        token,
        user,
        imageFile,
        oldImagePath,
      );

      return response;
    } catch (e) {
      throw Exception('Erro ao editar o usuário: $e');
    }
  }

  deleteUser(String token, User user) async {
    try {
      var response = await apiClient.deleteUser(token, user);

      return response;
    } catch (e) {
      throw Exception('Erro ao atualizar a família: $e');
    }
  }

  updateFirebaseTokenUser(String token, User user, String firebaseToken) async {
    try {
      var response =
          await apiClient.updateFirebaseTokenUser(token, user, firebaseToken);

      return response;
    } catch (e) {
      throw Exception('Erro ao atualizar a família: $e');
    }
  }
}
