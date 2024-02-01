import 'package:formapp/app/data/models/auth_model.dart';
import 'package:formapp/app/data/provider/auth_provider.dart';

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
}
