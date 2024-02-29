import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/user_provider.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getAll(String token) async {
    List<User> list = <User>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      list.add(User.fromJson(e));
    });

    return list;
  }

  insertUser(String token, User user) async {
    try {
      var response = await apiClient.insertUser(token, user);

      return response;
    } catch (e) {
      print('Erro ao inserir a usuário: $e');
      rethrow;
    }
  }

  updateUser(String token, User user) async {
    try {
      var response = await apiClient.updateUser(token, user);

      return response;
    } catch (e) {
      print('Erro ao atualizar a família: $e');
      rethrow;
    }
  }
}
