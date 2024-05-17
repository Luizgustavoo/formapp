import 'package:ucif/app/data/models/auth_model.dart';
import 'package:ucif/app/data/models/church_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/provider/auth_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';

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
      ErrorHandler.showError(e);
    }
  }

  forgotPassword(String username) async {
    try {
      var response = await apiClient.forgotPassword(username);
      if (response != null) return response;
    } catch (e) {
      // Exception(e);
    }
    return;
  }

  insertPeople(People pessoa) async {
    try {
      var response = await apiClient.insertPeople(pessoa);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  Future<List<MaritalStatus>> getMaritalStatus() async {
    List<MaritalStatus> list = <MaritalStatus>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getMaritalStatus();
      if (response != null) {
        response.forEach((e) {
          list.add(MaritalStatus.fromJson(e));
        });
      }
    }
    return list;
  }

  Future<List<Religion>> getReligion() async {
    List<Religion> list = <Religion>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getReligion();

      if (response != null) {
        response.forEach((e) {
          list.add(Religion.fromJson(e));
        });
      }
    }

    return list;
  }

  Future<List<Church>> getChurch() async {
    List<Church> list = <Church>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getChurch();

      if (response != null) {
        response.forEach((e) {
          list.add(Church.fromJson(e));
        });
      }
    }

    return list;
  }
}
