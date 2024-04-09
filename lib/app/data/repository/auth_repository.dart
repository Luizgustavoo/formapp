import 'package:ucif/app/data/models/auth_model.dart';
import 'package:ucif/app/data/provider/auth_provider.dart';

class AuthRepository {
  final AuthApiClient apiClient = AuthApiClient();

  Future<Auth?> getLogin(String username, String password) async {
    Map<String, dynamic>? json = await apiClient.getLogin(username, password);

    if (json != null) {
      return Auth.fromJson(json);
    } else {
      return null;
    }
  }

  getSignUp(String nome, String username, String senha) async {
    var json = await apiClient.getSignUp(nome, username, senha);

    if (json != null) {
      return json;
    } else {
      return null;
    }
  }

  Future<void> getLogout() async {
    try {
      await apiClient.getLogout();
    } catch (e) {
      throw Exception(e);
    }
  }

  forgotPassword(String username) async {
    try {
      var response = await apiClient.forgotPassword(username);
      if (response != null) return response;
    } catch (e) {
      throw Exception(e);
    }
    return;
  }
}
