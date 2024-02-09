import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/user_provider.dart';

class UserRepository {
  final UserApiClient apiClient = UserApiClient();

  getAll(String token) async {
    List<User> list = <User>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      // print(User.fromJson(e).toJson());
      list.add(User.fromJson(e));
    });

    // print("Usuário: ${list[0].username?[0]}");

    return list;
  }
}
