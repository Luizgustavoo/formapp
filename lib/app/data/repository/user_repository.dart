import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/user_provider.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getAll(String token) async {
    List<User> list = <User>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        list.add(User.fromJson(e));
      });
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

  updateUser(String token, User user) async {
    try {
      var response = await apiClient.updateUser(token, user);

      return response;
    } catch (e) {
      throw Exception('Erro ao atualizar a família: $e');
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
