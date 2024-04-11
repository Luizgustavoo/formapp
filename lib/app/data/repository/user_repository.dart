import 'dart:io';

import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/models/user_type_model.dart';
import 'package:ucif/app/data/provider/user_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getAll(String token, {int? page, String? search}) async {
    List<User> list = <User>[];

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token, page: page, search: search);
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

  Future<List<TypeUser>> getAllTypeUser(String token) async {
    List<TypeUser> list = <TypeUser>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAllTypeUser(token);

      if (response != null) {
        response.forEach((e) {
          list.add(TypeUser.fromJson(e));
        });
      }
    }
    return list;
  }

  approveUser(String token, int tipoUsuarioId, int idAprovacao, int idMensagem,
      int usuarioId, int familiaId, String action) async {
    try {
      var response = await apiClient.approveUser(token, tipoUsuarioId,
          idAprovacao, idMensagem, usuarioId, familiaId, action);

      return response;
    } catch (e) {
      throw Exception('Erro ao aprovar a usuário: $e');
    }
  }
}
