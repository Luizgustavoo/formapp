import 'package:get_storage/get_storage.dart';
import 'package:ucif/app/data/models/auth_model.dart';
import 'package:ucif/app/data/models/church_model.dart';
import 'package:ucif/app/data/models/health_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/medicine_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/auth_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';

class AuthRepository {
  final AuthApiClient apiClient = AuthApiClient();
  final box = GetStorage();

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

  insertPeople(People pessoa, List? saude, List? medicamento) async {
    try {
      var response = await apiClient.insertPeople(pessoa, saude, medicamento);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  Future<List<User>> getLeader() async {
    List<User> list = <User>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getLeader();
      if (response != null) {
        response.forEach((e) {
          list.add(User.fromJson(e));
        });
      }
    }
    return list;
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

  Future<List<Health>> getHealth() async {
    List<dynamic> localData = [];
    List<Health> localHealthList = [];

    if (box.hasData('health')) {
      localData = box.read<List<dynamic>>('health')!;
      localHealthList = localData
          .map((e) => Health.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Health> list = <Health>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getHealth();

      if (response != null) {
        response.forEach((e) {
          list.add(Health.fromJson(e));
        });

        box.write('health', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localHealthList;
    }

    return list;
  }

  Future<List<Medicine>> getMedicine() async {
    List<dynamic> localData = [];
    List<Medicine> localMedicineList = [];

    if (box.hasData('medicine')) {
      localData = box.read<List<dynamic>>('medicine')!;
      localMedicineList = localData
          .map((e) => Medicine.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<Medicine> list = <Medicine>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getMedicine();

      if (response != null) {
        response.forEach((e) {
          list.add(Medicine.fromJson(e));
        });

        box.write('medicine', list.map((e) => e.toJson()).toList());
      }
    } else {
      return localMedicineList;
    }

    return list;
  }
}
